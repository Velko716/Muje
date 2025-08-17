// functions/src/index.ts
import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2/options";

admin.initializeApp();

// ✅ v2: 리전/메모리 등 글로벌 옵션은 여기서
setGlobalOptions({ region: "asia-northeast3" });

type Msg = {
  sender_user_id: string;
  text: string;
  created_at?: FirebaseFirestore.Timestamp;
};

type Convo = {
  participants: string[];
  post_title?: string;
  participant1_name?: string;
  participant2_name?: string;
};

export const onMessageCreate = onDocumentCreated(
  "conversations/{cid}/messages/{mid}",
  async (event) => {
    const cid = event.params.cid as string;
    const snap = event.data;                // ✅ FirestoreEvent<DocumentSnapshot>
    if (!snap) return;

    const msg = snap.data() as Msg;
    // (옵션) 특정 문구는 푸시 제외
    if ((msg.text ?? "").trim() === "나갔습니다.") return;

    const db = admin.firestore();

    // 대화 문서 읽고 참가자/제목 가져오기
    const convoRef = db.collection("conversations").doc(cid);
    const convoSnap = await convoRef.get();
    if (!convoSnap.exists) return;

    const convo = convoSnap.data() as Convo;
    const participants = Array.isArray(convo.participants) ? convo.participants : [];
    const recipients = participants.filter((u) => u !== msg.sender_user_id);
    if (recipients.length === 0) return;

    // (옵션) 차단 필터링
    const filtered: string[] = [];
    for (const uid of recipients) {
      const blockSnap = await db
        .collection("users").doc(uid)
        .collection("blocks").doc(msg.sender_user_id)
        .get();
      if (!blockSnap.exists) filtered.push(uid);
    }
    if (filtered.length === 0) return;

    // 수신자 토큰 수집
    const tokens: string[] = [];
    for (const uid of filtered) {
      const tokSnap = await db.collection("users").doc(uid)
        .collection("fcm_tokens").get();
      tokSnap.docs.forEach((d) => tokens.push(d.id));
    }
    if (tokens.length === 0) return;

    // 페이로드
    const title = convo.post_title || "새 메시지";
    const body = msg.text.length > 80 ? msg.text.slice(0, 80) + "…" : msg.text;

    const multicast: admin.messaging.MulticastMessage = {
      tokens,
      notification: { title, body },
      data: { conversation_id: cid },
      apns: {
        headers: { "apns-priority": "10" },
        payload: { aps: { sound: "default", badge: 1 } },
      },
      android: { priority: "high" },
    };

    const res = await admin.messaging().sendEachForMulticast(multicast);

    // 무효 토큰 정리
    const invalid: string[] = [];
    res.responses.forEach((r, i) => {
      if (!r.success) {
        const code = (r.error as { code?: string } | undefined)?.code ?? "";
        if (code === "messaging/registration-token-not-registered" ||
            code === "messaging/invalid-registration-token") {
          invalid.push(tokens[i]);
        }
      }
    });

    if (invalid.length) {
      const cg = await db.collectionGroup("fcm_tokens")
        .where(admin.firestore.FieldPath.documentId(), "==", invalid[0]).get();
      await Promise.all(cg.docs.map((d) => d.ref.delete()));
      // 여러 개를 지우려면 invalid 배열을 순회해서 같은 로직을 돌리면 됩니다.
    }
  }
);