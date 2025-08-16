//
//  Message.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import FirebaseFirestore

struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    let senderUserId: String
    let text: String
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case senderUserId = "sender_user_id"
        case text
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    var createdDate: Date { createdAt?.dateValue() ?? .init() }
}
