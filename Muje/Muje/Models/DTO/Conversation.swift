//
//  Conversation.swift
//  Muje
//
//  Created by 김진혁 on 8/14/25.
//

import Foundation
import FirebaseFirestore


enum ParticipantRole: String, Codable {
    case recruiter
    case applicant
    
    var displayName: String {
        switch self {
        case .recruiter:
            "모집자"
        case .applicant:
            "참여자"
        }
    }
}

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
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    
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
        updatedAt: Timestamp? = nil
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
        case createdAt          = "created_at"
        case updatedAt          = "updated_at"
    }
}

extension Conversation: EntityRepresentable {    
    var entityName: CollectionType { .conversations }
    var documentID: String { conversationId.uuidString }
    var asDictionary: [String: Any]? {
        [
            "participant1_user_id": participant1UserId,
            "participant2_user_id": participant2UserId,
            "post_id": postId,
            "post_title": postTitle,
            "post_organization": postOrganization,
            "participant1_name": participant1Name,
            "participant1_role": participant1Role.rawValue,
            "participant2_name": participant2Name,
            "participant2_role": participant2Role.rawValue
        ]
    }
}
