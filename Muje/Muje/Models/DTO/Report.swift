//
//  Report.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation
import FirebaseFirestore

struct Report: Codable {
    var reportId: UUID
    let reporterUserId: String
    let reportedUserId: String
    var postId: String?
    var conversationId: String?
    var messageId: String?
    let reportType: String
    var reason: String?
    var status: String
    
    @ServerTimestamp var createdAt: Timestamp? = nil
    
    init(
        reportId: UUID,
        reporterUserId: String,
        reportedUserId: String,
        postId: String? = nil,
        conversationId: String? = nil,
        messageId: String? = nil,
        reportType: ReportType.RawValue,
        reason: String? = nil,
        status: ReportStatus.RawValue,
        createdAt: Timestamp? = nil
    ) {
        self.reportId = reportId
        self.reporterUserId = reporterUserId
        self.reportedUserId = reportedUserId
        self.postId = postId
        self.conversationId = conversationId
        self.messageId = messageId
        self.reportType = reportType
        self.reason = reason
        self.status = status
        self.createdAt = createdAt
    }
    
    
    enum CodingKeys: String, CodingKey {
        case reportId = "report_id"
        case reporterUserId = "reporter_user_id"
        case reportedUserId = "reported_user_id"
        case postId = "post_id"
        case conversationId = "conversation_id"
        case messageId = "message_id"
        case reportType = "report_type"
        case reason
        case status
        case createdAt = "created_at"
    }
}

extension Report: EntityRepresentable {
    var entityName: CollectionType { .reports }
    
    var documentID: String { reportId.uuidString }
    
    var asDictionary: [String: Any]? {
        var dict: [String: Any] = [
            "report_id": reportId.uuidString,
            "reporter_user_id": reporterUserId,
            "reported_user_id": reportedUserId,
            "report_type": reportType,
            "status": status,
            //"created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
        
        if let postId = postId {
            dict["post_id"] = postId
        }
        if let conversationId = conversationId {
            dict["conversation_id"] = conversationId
        }
        if let messageId = messageId {
            dict["message_id"] = messageId
        }
        if let reason = reason {
            dict["reason"] = reason
        }
        
        return dict
    }
}
