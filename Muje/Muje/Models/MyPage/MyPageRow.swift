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
        case action(id: String, title: String, action: () -> Void)
    }
    var kind: Kind
    
    var id: String {
        switch kind {
        case .value(let title, _):
            return "value.\(title)"
        case .action(let id, _, _):
            return "action.\(id)"
        }
    }
}
// 안정 키만 계산해 주는 가벼운 익스텐션
extension MyPageRow {
    var stableID: String {
        switch kind {
        case .value(let title, _):
            return "value.\(title)"
        case .action(let id, _, _):
            return "action.\(id)" 
        }
    }
}


