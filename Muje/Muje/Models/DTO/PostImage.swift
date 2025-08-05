//
//  PostImage.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct PostImage: Codable {
    var imageId: UUID
    let postId: String
    let imageUrl: String
    let imageOrder: Int
    @ServerTimestamp var createdAt: Timestamp? 
    
    init(
        imageId: UUID,
        postId: String,
        imageUrl: String,
        imageOrder: Int,
        createdAt: Timestamp? = nil
    ) {
        self.imageId = imageId
        self.postId = postId
        self.imageUrl = imageUrl
        self.imageOrder = imageOrder
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case imageId = "image_id"
        case postId = "post_id"
        case imageUrl = "image_url"
        case imageOrder = "image_order"
        case createdAt = "created_at"
    }
}

extension PostImage: EntityRepresentable {
    var entityName: CollectionType { .postImages }
    
    var documentID: String { imageId.uuidString }
        
    var asDictionary: [String: Any]? {
        [
            "image_id": imageId.uuidString,
            "post_id": postId,
            "image_url": imageUrl,
            "image_order": imageOrder,
            //"created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
