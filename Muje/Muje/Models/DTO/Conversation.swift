//
//  Conversation.swift
//  Muje
//
//  Created by 김진혁 on 8/14/25.
//

import Foundation
import FirebaseFirestore

struct Conversation: Codable {
    var conversationId: UUID
    let participant1UserId: String
    let participant2UserId: String
    let postId: String
    let postTitle: String
    let postOrganization: String
    let participant1Name: String
    let participant1Role: ParticipantRole
    let participant2Name: String
    let participant2Role: ParticipantRole
    
    // 미리보기/정렬용
    var lastMessageText: String? = nil
    var lastSenderUserId: String? = nil
    var lastMessageAt: Timestamp? = nil
    
    // 사용자별 미읽음 수 (키: userId)
    var unread: [String: Int64]? = nil
    
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    
    /// 쿼리용 편의 프로퍼티 
    var participants: [String] { [participant1UserId, participant2UserId] }
    
    init(
        conversationId: UUID,
        participant1UserId: String,
        participant2UserId: String,
        postId: String,
        postTitle: String,
        postOrganization: String,
        participant1Name: String,
        participant1Role: ParticipantRole,
        participant2Name: String,
        participant2Role: ParticipantRole,
        createdAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil,
        lastMessageText: String? = nil,
        lastSenderUserId: String? = nil,
        lastMessageAt: Timestamp? = nil
    ) {
        self.conversationId = conversationId
        self.participant1UserId = participant1UserId
        self.participant2UserId = participant2UserId
        self.postId = postId
        self.postTitle = postTitle
        self.postOrganization = postOrganization
        self.participant1Name = participant1Name
        self.participant1Role = participant1Role
        self.participant2Name = participant2Name
        self.participant2Role = participant2Role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastMessageText = lastMessageText
        self.lastSenderUserId = lastSenderUserId
        self.lastMessageAt = lastMessageAt
    }
    
    enum CodingKeys: String, CodingKey {
        case conversationId     = "conversation_id"
        case participant1UserId = "participant1_user_id"
        case participant2UserId = "participant2_user_id"
        case postId             = "post_id"
        case postTitle          = "post_title"
        case postOrganization   = "post_organization"
        case participant1Name   = "participant1_name"
        case participant1Role   = "participant1_role"
        case participant2Name   = "participant2_name"
        case participant2Role   = "participant2_role"
        case lastMessageText    = "last_message"
        case lastSenderUserId   = "last_sender_user_id"
        case lastMessageAt      = "last_message_at"    // ← 이제 Optional Timestamp?로 안전
        case createdAt          = "created_at"
        case updatedAt          = "updated_at"
    }
    
    /// 편의: 특정 사용자 미읽음 수
    func unreadCount(for userId: String) -> Int {
        Int(unread?[userId] ?? 0)
    }
}

extension Conversation: EntityRepresentable {
    var entityName: CollectionType { .conversations }
    var documentID: String { conversationId.uuidString }

    var asDictionary: [String: Any]? {
        var dict: [String: Any] = [
            "conversation_id": conversationId.uuidString,
            "participant1_user_id": participant1UserId,
            "participant2_user_id": participant2UserId,
            "post_id": postId,
            "post_title": postTitle,
            "post_organization": postOrganization,
            "participant1_name": participant1Name,
            "participant1_role": participant1Role.rawValue,
            "participant2_name": participant2Name,
            "participant2_role": participant2Role.rawValue,
            "participants": [participant1UserId, participant2UserId]
        ]
        if let lastMessageText { dict["last_message"] = lastMessageText }
        if let lastSenderUserId { dict["last_sender_user_id"] = lastSenderUserId }
        // last_message_at 은 sendMessage 배치에서 FieldValue.serverTimestamp()로 세팅
        return dict
    }
}

