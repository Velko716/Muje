//
//  RecruitmentStatus.swift
//  Muje
//
//  Created by 김서현 on 9/3/25.
//

import SwiftUI

/// 공고 상태 별로 컬러와 배경색을 지정함
enum RecruitmentStatus {
    case recruiting
    case completed
    case hasInterview
    
    var text: String {
        switch self {
        case .recruiting: "모집 중"
        case .completed: "모집 마감"
        case .hasInterview: "면접 진행"
        }
    }
    
    var textColor: Color {
        switch self {
        case .recruiting:
                .statusTextGreen
        case .completed:
                .statusTextRed
        case .hasInterview:
                .statusTextBlue
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .recruiting:
                .statusContainerGreen
        case .completed:
                .statusContainerRed
        case .hasInterview:
                .statusContainerBlue
        }
    }
}
