//
//  ReportType.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportType: String, Codable {
    case spam = "spam"
    case abuse = "abuse"
    case inappropriate = "inappropriate"
}
