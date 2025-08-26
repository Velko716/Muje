//
//  ReportType.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportType: String, Codable {
    case spam = "스팸/도배"
    case inappropriateContent = "부적절한 내용"
    case harassment = "괴롭힘/욕설"
    case fraud = "사기/허위 정보"
    case other = "기타"
}
