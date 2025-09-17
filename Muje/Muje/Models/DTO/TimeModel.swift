//
//  InterviewSlot.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct TimeModel: Equatable, Hashable, Codable {
    var timeId: UUID
    var postId: String
    var startTime: Timestamp
    var endTime: Timestamp
    var isStartShown: Bool
    var isEndShown: Bool
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    init(
        timeId: UUID,
        postId: String,
        startTime: Timestamp,
        endTime: Timestamp,
        isStartShown: Bool,
        isEndShown: Bool,
        createdAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil
    ) {
        self.timeId = timeId
        self.postId = postId
        self.startTime = startTime
        self.endTime = endTime
        self.isStartShown = isStartShown
        self.isEndShown = isEndShown
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case timeId = "time_id"
        case postId = "post_id"
        case startTime = "start_time"
        case endTime = "end_Time"
        case isStartShown = "is_start_shown"
        case isEndShown = "isEndShown"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


extension TimeModel: EntityRepresentable {
    var entityName: CollectionType { .timeModel }

    var documentID: String { timeId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "time_id": timeId.uuidString,
            "post_id": postId,
            "start_time": startTime,
            "end_Time": endTime,
            "is_start_shown": isStartShown,
            "isEndShown": isEndShown,
            "created_at": createdAt ?? FieldValue.serverTimestamp(),
            "updated_at": updatedAt ?? FieldValue.serverTimestamp()
        ]
    }
}
