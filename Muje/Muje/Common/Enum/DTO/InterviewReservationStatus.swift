//
//  InterviewReservationStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation

enum InterviewReservationStatus: String, Codable {
    case reserved = "reserved"
    case completed = "completed"
    case cancelled = "cancelled"
}
