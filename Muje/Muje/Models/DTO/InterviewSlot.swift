//
//  InterviewSlot.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct InterviewSlot: Codable {
    let slotId: UUID
    let postId: String
    let interviewDate: Timestamp
    let interviewTime: String
    var maxCapacity: Int
    var currentReservations: Int
    @ServerTimestamp var createdAt: Timestamp?

    init(
        slotId: UUID,
        postId: String,
        interviewDate: Timestamp,
        interviewTime: String,
        maxCapacity: Int = 1,
        currentReservations: Int = 0,
        createdAt: Timestamp?
    ) {
        self.slotId = slotId
        self.postId = postId
        self.interviewDate = interviewDate
        self.interviewTime = interviewTime
        self.maxCapacity = maxCapacity
        self.currentReservations = currentReservations
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case slotId = "slot_id"
        case postId = "post_id"
        case interviewDate = "interview_date"
        case interviewTime = "interview_time"
        case maxCapacity = "max_capacity"
        case currentReservations = "current_reservations"
        case createdAt = "created_at"
    }
}


extension InterviewSlot: EntityRepresentable {
    var entityName: CollectionType { .interviewSlots }

    var documentID: String { slotId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "slot_id": slotId.uuidString,
            "post_id": postId,
            "interview_date": interviewDate,
            "interview_time": interviewTime,
            "max_capacity": maxCapacity,
            "current_reservations": currentReservations,
            // "created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
