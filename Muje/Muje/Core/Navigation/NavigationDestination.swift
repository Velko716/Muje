//
//  NavigationDestination.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
    case contentView // 임시
    case RecruitmentDetailView(postId: String)
    case ApplicationFormView(postId: String, requirementFlags: RequirementFlags)
    
}
