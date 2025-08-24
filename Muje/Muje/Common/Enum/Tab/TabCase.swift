//
//  TabCase.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

enum TabCase: String, CaseIterable, Identifiable {
    case myPosts = "내 모임"
    case home = "홈"
    case inbox = "쪽지"
    
    var id: String { rawValue }
    
    var icon: String { // FIXME: - 아이콘 타입 Image로 변경
        switch self {
        case .myPosts: return "post"
        case .home: return "home"
        case .inbox: return "inbox"
        }
    }
}


