//
//  InboxNavigationChipType.swift
//  Muje
//
//  Created by 김진혁 on 8/15/25.
//

import Foundation

enum InboxNavigationChipType {
    case applicant
    case recruiter
    
    var displayName: String {
        switch self {
        case .applicant:
            return "지원자"
        case .recruiter:
            return "모집자"
        }
    }
    
    // FIXME: - 컬러 수정
    var color: Color {
        switch self {
        case .applicant:
            return .red
        case .recruiter:
            return .blue
        }
    }
}
