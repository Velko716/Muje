//
//  MyPageRow.swift
//  Muje
//
//  Created by 김진혁 on 8/25/25.
//

import Foundation

struct MyPageRow: Identifiable {
    enum Kind {
        case value(title: String, value: String)
        case action(title: String, action: () -> Void)
    }
    
    let id = UUID()
    var kind: Kind
}
