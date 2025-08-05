//
//  ReportStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportStatus: String, Codable {
    case pending = "접수됨"
    case reviewing = "검토중"
    case resolved = "해결됨"
    case dismissed = "기각됨"
}
