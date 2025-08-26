//
//  ReportType.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportType: String, Codable {
    case spam = "spam"
    case inappropriateContent = "inappropriateContent"
    case harassment = "harassment"
    case fraud = "fraud"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .spam:
            return "스팸/도배"
        case .inappropriateContent:
            return "부적절한 내용"
        case .harassment:
            return "괴롭힘/욕설"
        case .fraud:
            return "사기/허위 정보"
        case .other:
            return "기타"
        }
    }
}
