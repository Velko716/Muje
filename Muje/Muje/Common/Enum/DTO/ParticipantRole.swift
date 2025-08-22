//
//  ParticipantRole.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import Foundation

enum ParticipantRole: String, Codable {
    case recruiter
    case applicant
    
    var displayName: String {
        switch self {
        case .recruiter: "모집자"
        case .applicant: "참여자"
        }
    }
}
