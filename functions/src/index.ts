import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2/options";

admin.initializeApp();
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

// 차단 여부 확인
async function isBlocked(db: FirebaseFirestore.Firestore, targetUid: string, fromUid: string): Promise<boolean> {
  const snap = await db
    .collection("users").doc(targetUid)
    .collection("blocks").doc(fromUid)
    .get();
  return snap.exists;
}

// 해당 유저의 FCM 토큰 전부 수집
async function getUserTokens(db: FirebaseFirestore.Firestore, uid: string): Promise<string[]> {
  const tokSnap = await db.collection("users").doc(uid).collection("fcm_tokens").get();
  return tokSnap.docs.map((d) => d.id);
}

// 해당 유저의 총 미읽음 개수 계산
// conversations 콜렉션에서 participants 에 uid 가 포함된 문서를 전부 읽고,
// 각 문서의 unread_<uid> 값을 합산
async function computeUnreadTotalFor(db: FirebaseFirestore.Firestore, uid: string): Promise<number> {
  const qs = await db
    .collection("conversations")
    .where("participants", "array-contains", uid)
    .get();

  const key = `unread_${uid}`;
  let total = 0;

  qs.forEach((doc) => {
    const data = doc.data() || {};
    const v = (data as any)[key];
    if (typeof v === "number") total += v;
    else if (v && typeof (v as any).toNumber === "function") total += (v as any).toNumber();
  });

  return total;
}

export const onMessageCreate = onDocumentCreated(
  "conversations/{cid}/messages/{mid}",
  async (event) => {
    const cid = event.params.cid as string;
    const snap = event.data;
    if (!snap) return;

    const msg = snap.data() as Msg;
    if ((msg.text ?? "").trim() === "나갔습니다.") return;

    const db = admin.firestore();

    // 대화 문서 읽기
    const convoRef = db.collection("conversations").doc(cid);
    const convoSnap = await convoRef.get();
    if (!convoSnap.exists) return;

    const convo = convoSnap.data() as Convo;
    const participants = Array.isArray(convo.participants) ? convo.participants : [];
    const recipients = participants.filter((u) => u !== msg.sender_user_id);
    if (recipients.length === 0) return;

    // 알림 제목/본문
    const title = convo.post_title || "새 메시지";
    const body = (msg.text || "").length > 80 ? msg.text.slice(0, 80) + "…" : (msg.text || "");

    // 수신자별로 처리 (차단 제외, 토큰 수집, 총 미읽음 계산, 배지 포함 전송)
    for (const uid of recipients) {
      const blocked = await isBlocked(db, uid, msg.sender_user_id);
      if (blocked) continue;

      const tokens = await getUserTokens(db, uid);
      if (tokens.length === 0) continue;

      // ✅ 여기서 '총 미읽음'을 계산해서 APNs 배지에 넣는다
      const badgeCount = await computeUnreadTotalFor(db, uid);

      const multicast: admin.messaging.MulticastMessage = {
        tokens,
        notification: { title, body },
        data: { conversation_id: cid },
        apns: {
          headers: { "apns-priority": "10" },
          payload: {
            aps: {
              sound: "default",
              badge: badgeCount, // ← 핵심: 유저별 총 미읽음
            },
          },
        },
        android: { priority: "high" },
      };

      const res = await admin.messaging().sendEachForMulticast(multicast);

      // 무효 토큰 정리
      const invalid: string[] = [];
      res.responses.forEach((r, i) => {
        if (!r.success) {
          const code = (r.error as { code?: string } | undefined)?.code ?? "";
          if (
            code === "messaging/registration-token-not-registered" ||
            code === "messaging/invalid-registration-token"
          ) {
            invalid.push(tokens[i]);
          }
        }
      });

      if (invalid.length) {
        // 같은 토큰 값으로 문서 ID를 사용하는 구조일 때만 동작
        // (여러 개면 for..of 로 돌려서 모두 정리하세요)
        const cg = await db
          .collectionGroup("fcm_tokens")
          .where(admin.firestore.FieldPath.documentId(), "==", invalid[0])
          .get();
        await Promise.all(cg.docs.map((d) => d.ref.delete()));
      }
    }
  }
);