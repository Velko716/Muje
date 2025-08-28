//
//  MyPageSection.swift
//  Muje
//
//  Created by 김진혁 on 8/25/25.
//

import Foundation

struct MyPageSection: Identifiable {
    var header: String
    var rows: [MyPageRow]
    var id: String { header }
}

extension MyPageSection {
    var stableID: String { header }
