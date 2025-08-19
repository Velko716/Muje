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
    let db = Firestore.firestore()
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
        order: String = "createdAt",
        descending: Bool = true,
        count: Int = 0
    ) async throws -> [T] {
        var query: Query = db.collection(collectionType.rawValue)
        
        if count > 0 {
            query = query.limit(to: count) }
        
        let snapshot = try await query.getDocuments()
        print("📄 문서 개수: \(snapshot.documents.count)") // 디버그용
        
        let items = snapshot.documents.compactMap { document in
            do {
                let decoded = try document.data(as: T.self)

                return decoded
            } catch {
                return nil
            }
        }
        
        
        print("✅ 최종 아이템 개수: \(items.count)")
        return items
    }
}
