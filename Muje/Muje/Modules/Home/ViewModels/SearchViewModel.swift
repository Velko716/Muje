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

    
    init() {
        searchResults = []
        searchText = ""
    }
    
    func filterPosts() {
        print("🔫 filterPosts 작동")
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
