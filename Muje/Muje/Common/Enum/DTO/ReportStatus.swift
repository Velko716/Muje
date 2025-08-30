//
//  ReportStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportStatus: String, Codable {
    case pending = "pending"
    case reviewing = "reviewing"
    case resolved = "resolved"
    case dismissed = "dismissed"
    
    var displayName: String {
        switch self {
        case .pending:
            return "접수됨"
        case .reviewing:
            return "검토중"
        case .resolved:
            return "해결됨"
        case .dismissed:
            return "기각됨"
        }
    }
}
