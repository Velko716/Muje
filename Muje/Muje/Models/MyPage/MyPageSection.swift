//
//  MyPageSection.swift
//  Muje
//
//  Created by 김진혁 on 8/25/25.
//

import Foundation

struct MyPageSection: Identifiable {
    let id = UUID()
    var header: String
    var rows: [MyPageRow]
}
