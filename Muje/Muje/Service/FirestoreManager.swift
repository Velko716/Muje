//
//  FirestoreManager.swift
//  Muje
//
//  Created by 김진혁 on 8/1/25.
//

import FirebaseFirestore

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    let db = Firestore.firestore()
    private init() {}
    
    private func save<T: EntityRepresentable>(
        _ data: T,
        isCreate: Bool
    ) async throws -> T {
        guard var dict = data.asDictionary else { throw FirestoreError.encodingFailed }
        
        if isCreate {
            dict["created_at"] = FieldValue.serverTimestamp()
        }
        
        dict["updated_at"] = FieldValue.serverTimestamp()
        
        let ref = db
            .collection(data.entityName.rawValue)
            .document(data.documentID)
        
        if isCreate {
            try await ref.setData(dict)
        } else {
            try await ref.updateData(dict)
        }
        return data
    }
    
    func create<T: EntityRepresentable>(_ data: T) async throws -> T {
        try await save(data, isCreate: true)
    }
    
    func update<T: EntityRepresentable>(_ data: T) async throws -> T {
        try await save(data, isCreate: false)
    }
    
    func get<T: Decodable>(_ id: String, from type: CollectionType) async throws -> T {
        let snapshot = try await db.collection(type.rawValue).document(id).getDocument()
        guard let data = try? snapshot.data(as: T.self) else {
            throw FirestoreError.fetchFailed(
                underlying: NSError(
                    domain: "", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "문서가 존재하지 않습니다."]
                )
            )
        }
        return data
    }
    
    func delete(collectionType: CollectionType, documentID: String) async throws {
        try await db
            .collection(collectionType.rawValue)
            .document(documentID)
            .delete()
    }
    
}

// FIXME: - 임시 (UUID -> UUIDString)
extension FirestoreManager {
    func fetchBlocks(for userId: UUID) async throws -> [Block] {
        let snapshot = try await db
            .collection("User")
            .document(userId.uuidString)
            .collection("blocks")
            .order(by: "created_at", descending: true)
            .getDocuments()
        
        let blocks = try snapshot.documents.compactMap { document in
            try document.data(as: Block.self)
        }
        
        return blocks
    }
    
    func fetchWithCondition<T: Decodable>(
        from collectionType: CollectionType,
        whereField field: String,
        equalTo value: Any,
        sortedBy sortComparator: @escaping (T, T) -> Bool
    ) async throws -> [T] {
        
        let snapshot = try await db
            .collection(collectionType.rawValue)
            .whereField(field, isEqualTo: value)
            .getDocuments()
        
        let items = snapshot.documents.compactMap { document in
            do {
                return try document.data(as: T.self)
            } catch {
                print("fetch 디코딩 실패 \(error)")
                return nil
            }
        }
        return items.sorted(by: sortComparator)
    }
}

// MARK: - 쪽지 내용 관련
extension FirestoreManager {
    
    // 메시지 전송 + 대화 메타 동시 업데이트
    func sendMessage(
        conversationId: UUID,
        senderUserId: String,
        text: String
    ) async throws {
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty else { return }
        
        let convoRef = db.collection("conversations").document(conversationId.uuidString)
        let msgRef = convoRef.collection("messages").document()
        
        // 대화 참여자 가져오기
        let convoSnap = try await convoRef.getDocument()
        let p1 = convoSnap.get("participant1_user_id") as? String ?? ""
        let p2 = convoSnap.get("participant2_user_id") as? String ?? ""
        let recipients = [p1, p2].filter { $0 != senderUserId }   // 보낸 사람 제외
        
        let batch = db.batch()
        
        // 메시지 생성
        batch.setData([
            "sender_user_id": senderUserId,
            "text": body,
            "created_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ], forDocument: msgRef)
        
        // 대화 메타 갱신 + 상대방 미읽음 +1
        var convoUpdate: [String: Any] = [
            "last_message": body,
            "last_sender_user_id": senderUserId,
            "last_message_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ]
        // 여러 명일 수 있으니 루프 가능
        recipients.forEach { rid in
            convoUpdate["unread.\(rid)"] = FieldValue.increment(Int64(1))
        }
        
        batch.setData(convoUpdate, forDocument: convoRef, merge: true)
        
        try await batch.commit()
    }
    
    /// 읽음 수를 0으로 초기화하는 메서드 입니다.
    func markConversationRead(conversationId: UUID, userId: String) async throws {
        let convoRef = db.collection("conversations").document(conversationId.uuidString)
        try await convoRef.setData([
            "unread.\(userId)": 0,
            "read_states.\(userId).last_read_at": FieldValue.serverTimestamp()
        ], merge: true)
    }
    
    // 실시간 구독: 최신 n개를 받아서 UI는 정방향으로 사용
    // onChange로 역순을 뒤집어 전달하고, 가장 오래된 문서 스냅샷(페이징 커서)도 함께 전달
    func listenMessages(
        conversationId: UUID,
        pageSize: Int = 30,
        onChange: @escaping ([Message], DocumentSnapshot?) -> Void
    ) -> ListenerRegistration {
        let ref = db.collection("conversations")
            .document(conversationId.uuidString)
            .collection("messages")
        
        let q = ref.order(by: "created_at", descending: true).limit(to: pageSize)
        
        return q.addSnapshotListener { snapshot, _ in
            guard let docs = snapshot?.documents else {
                onChange([], nil)
                return
            }
            let page = docs.compactMap { try? $0.data(as: Message.self) }.reversed()
            onChange(Array(page), docs.last) // docs.last = 이 페이지에서 가장 오래된 문서
        }
    }
    
    // 과거 페이지 더 불러오기(페이징)
    func fetchMoreMessages(
        conversationId: UUID,
        after oldestCursor: DocumentSnapshot,
        pageSize: Int = 30
    ) async throws -> ([Message], DocumentSnapshot?) {
        let ref = db.collection("conversations")
            .document(conversationId.uuidString)
            .collection("messages")
        
        let snap = try await ref
            .order(by: "created_at", descending: true)
            .start(afterDocument: oldestCursor)
            .limit(to: pageSize)
            .getDocuments()
        
        let items = snap.documents.compactMap { try? $0.data(as: Message.self) }.reversed()
        return (Array(items), snap.documents.last)
    }
    
    /// 나가기: 참가자 배열에서 내 UID 제거 + 감사 로그 기록
    func leaveConversation(conversationId: UUID, userId: String) async throws {
        let convoRef = db.collection("conversations").document(conversationId.uuidString)

        let snap = try await convoRef.getDocument()
        let data = snap.data() ?? [:]
        let participants = data["participants"] as? [String] ?? []

        if participants == [userId] || participants.isEmpty {
            try await convoRef.delete() // 내가 마지막 참가자면 방 문서 삭제
            return
        }

        // 그 외: 내 UID만 제거
        try await convoRef.updateData([
            "participants": FieldValue.arrayRemove([userId]),
            "left_users": FieldValue.arrayUnion([userId]),
            "left_at.\(userId)": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ])
    }
}

// MARK: - 쪽지 리스트(실시간)
extension FirestoreManager {
    /// 현재 유저가 포함된 대화 목록을 실시간으로 구독
    /// - Returns: ListenerRegistration (해제는 remove() 호출)
    func listenConversationsForUser(
        _ userId: String,
        onChange: @escaping ([Conversation]) -> Void
    ) -> ListenerRegistration {

        let q = db.collection("conversations")
            .whereField("participants", arrayContains: userId)
            .order(by: "updated_at", descending: true)

        return q.addSnapshotListener { snap, err in
            guard let snap else {
                onChange([])
                return
            }

            // 디코드
            var list: [Conversation] = snap.documents.compactMap { doc in
                do {
                    var convo = try doc.data(as: Conversation.self)

                    // (선택) unread가 디코드 안 될 때 수동 파싱 — 타입 불일치 방지
                    if convo.unread == nil, let raw = doc.data()["unread"] as? [String: Any] {
                        var parsed: [String: Int64] = [:]
                        for (k, v) in raw {
                            if let n = v as? NSNumber { parsed[k] = n.int64Value }
                            else if let i = v as? Int { parsed[k] = Int64(i) }
                            else if let i64 = v as? Int64 { parsed[k] = i64 }
                            else if let d = v as? Double { parsed[k] = Int64(d) }
                        }
                        if !parsed.isEmpty { convo.unread = parsed }
                    }

                    return convo
                } catch {
                    print("DECODE FAIL \(doc.documentID):", error)
                    return nil
                }
            }

            // 쿼리에서 이미 정렬하지만, 안전하게 한 번 더
            list.sort {
                let l = $0.updatedAt?.dateValue() ?? $0.createdAt?.dateValue() ?? .distantPast
                let r = $1.updatedAt?.dateValue() ?? $1.createdAt?.dateValue() ?? .distantPast
                return l > r
            }

            onChange(list)
        }
    }
}
