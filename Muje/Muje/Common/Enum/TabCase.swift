//
//  TabCase.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

enum TabCase: String, CaseIterable, Identifiable {
    case home = "홈"
    case myPosts = "나의 공고"
    case inbox = "쪽지"
    case myPage = "마이 페이지"
    
    var id: String { rawValue }
    
    var icon: String { // FIXME: - 아이콘 타입 Image로 변경 
        switch self {
        case .home: return "house"
        case .myPosts: return "doc.text"
        case .inbox: return "envelope"
        case .myPage: return "person.crop.circle"
        }
    }
    
}


