//
//  SearchViewModel.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

//뷰모델에서 관리할 것 : 입력 상태, 검색어 타이핑한 거, 비동기 처리 필터링

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine

@Observable
final class SearchViewModel {
    var searchText = ""
    var allPosts: [Post] = []
    var searchResults: [Post] = []
    var errorMessage: String?
    var searchState: SearchStatus = .typing
    
    
    init() {
        searchResults = []
        searchText = ""
        allPosts = [
            Post(postId: UUID(), authorUserId: "temp", title: "동아리 모집합니다", organization: "세오의동아리", content: "내용입니다.", recruitmentStart: Timestamp(date: Date()), recruitmentEnd: Timestamp(date: Date()), hasInterview: true, status: "모집중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "temp", authorOrganization: "세오의 동아리", createdAt: Timestamp(date: Date()), updatedAt: Timestamp(date: Date())),
            Post(postId: UUID(), authorUserId: "temp", title: "동아리 모집합니다", organization: "서혀니의동아리", content: "내용입니다.", recruitmentStart: Timestamp(date: Date()), recruitmentEnd: Timestamp(date: Date()), hasInterview: true, status: "모집중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "temp", authorOrganization: "서혀니의 동아리", createdAt: Timestamp(date: Date()), updatedAt: Timestamp(date: Date()))
        ]
    }
    
    func filterPosts() {
        print("🔫 filterPosts 작동\n검색어 : \(searchText)")
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = allPosts.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.content.localizedStandardContains(searchText) ||
                post.authorName.localizedCaseInsensitiveContains(searchText) ||
                post.organization.localizedStandardContains(searchText) ||
                post.authorOrganization.localizedStandardContains(searchText)
                
            }
        }
    }
    
}
