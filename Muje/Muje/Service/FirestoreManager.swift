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
