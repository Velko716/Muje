//
//  FirestoreManager.swift
//  Muje
//
//  Created by 김진혁 on 8/1/25.
//

import FirebaseStorage
import FirebaseFirestore

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage() //이미지를 불러오기 위함인데 잠시 대기
    
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
    // collectionType: 해당 데이터가 어떤 유형인지
    // order: 정렬 방식
    // count: 가져오는 개수(0이면 전부 가져옴)
    func fetchPosts<T: Decodable>(
        as type: T.Type,
        _ collectionType: CollectionType,
        order: String = "created_at",
        descending: Bool = true,
        count: Int = 0
    ) async throws -> [T] {
        var query: Query = db.collection(collectionType.rawValue)
        query = query.order(by: order, descending: true)
        if count > 0 {
            query = query.limit(to: count) }
        
        let snapshot = try await query.getDocuments()
        
        let items = snapshot.documents.compactMap { document in
            do {
                let decoded = try document.data(as: T.self)
                
                return decoded
            } catch {
                return nil
            }
        }
        return items
    }
    
    func getDownloadURL(for storagePath: String) async throws -> URL {
        let storageRef = Storage.storage().reference(withPath: "images/\(storagePath)")
        let url = try await storageRef.downloadURL()
        return url
    }
    
    //썸네일 PostImage 목록 가져오기
    func fetchThumbnailImages(for postIds: [UUID]) async throws -> [PostImage] {
        guard !postIds.isEmpty else { return [] }
        
        // UUID를 String으로 변환
        let postIdStrings = postIds.map { $0.uuidString }
        
        //post_image 콜렉션의 문서를 모두 가져옴
        let query = db.collection("post_images")
            .whereField("postId", in: postIdStrings)
            .whereField("image_order", isEqualTo: 0)
        
        let snapshot = try await query.getDocuments()
        
        var thumbnails: [PostImage] = []
        
        for document in snapshot.documents {
            do {
                let postImage = try document.data(as: PostImage.self)
                thumbnails.append(postImage)
            } catch {
                print("Error decoding PostImage : \(error)")
            }
        }
        return thumbnails
    }
    
    // 실제 이미지를 storage에서 병렬 처리로 가져오는 함수, UUID(post_id)와 PostImage를 딕셔너리 형태로 묶어서 관리
    func fetchThumbnailUIImages(from postImages: [PostImage]) async -> [UUID: UIImage] {
        var result: [UUID: UIImage] = [:]
        
        await withTaskGroup(of: (UUID, UIImage?)?.self) { group in
            for postImage in postImages {
                group.addTask {
                    guard let uuid = UUID(uuidString: postImage.postId) else { return nil }
                    let path = "post_images/\(postImage.postId)/\(postImage.imageId).jpg"
                    
                    do {
                        let ref = Storage.storage().reference(withPath: path)
                        let url = try await ref.downloadURL()
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            return (uuid, image)
                        }
                    } catch {
                        print("❌ Failed to load image for \(postImage.postId):", error)
                    }
                    return nil
                }
            }
            
            for await item in group {
                if let (uuid, image) = item {
                    result[uuid] = image
                }
            }
        }
        
        return result
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
            convoUpdate["unread_\(rid)"] = FieldValue.increment(Int64(1))
        }
        
        batch.setData(convoUpdate, forDocument: convoRef, merge: true)
        
        try await batch.commit()
    }
    
    /// 읽음 수를 0으로 초기화하는 메서드 입니다.
    func markConversationRead(conversationId: UUID, userId: String) async throws {
        let convoRef = db.collection("conversations").document(conversationId.uuidString)
        try await convoRef.setData([
            "unread_\(userId)": 0,
            "read_states_\(userId)_last_read_at": FieldValue.serverTimestamp()
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
            "left_at_\(userId)": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ])
    }
}

// MARK: - 쪽지 리스트(실시간)
extension FirestoreManager {
    /// 대화 목록 실시간 리스너
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
            
            var list: [Conversation] = []
            
            for doc in snap.documents {
                do {
                    var convo = try doc.data(as: Conversation.self)
                    var unreadDict: [String: Int] = [:]
                    let rawData = doc.data()
                    for (key, value) in rawData {
                        if key.hasPrefix("unread_"),
                           let id = key.components(separatedBy: "unread_").last,
                           let count = value as? Int {
                            unreadDict[id] = count
                        }
                    }
                    convo.unread = unreadDict
                    list.append(convo)
                } catch {
                    print("decode error \(doc.documentID):", error)
                }
            }
            
            // 최신순 정렬
            list.sort {
                let l = $0.updatedAt?.dateValue() ?? $0.createdAt?.dateValue() ?? .distantPast
                let r = $1.updatedAt?.dateValue() ?? $1.createdAt?.dateValue() ?? .distantPast
                return l > r
            }
            
            onChange(list)
        }
    }
}

