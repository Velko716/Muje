//
//  ReportRow.swift
//  Muje
//
//  Created by 김진혁 on 8/30/25.
//

import Foundation

struct ReportRow: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    let content: String
}
