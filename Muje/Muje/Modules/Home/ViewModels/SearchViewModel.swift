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
    let allPosts: [Post]
    var searchText = ""
    var searchResults: [Post] = []
    var errorMessage: String?
    var searchState: SearchStatus = .typing
    
    init(posts: [Post]) {
        searchResults = []
        searchText = ""
        self.allPosts = posts
    }
    //FIXME: 지금 단계에서는 post 전체를 불러와서 swift의 filter 메서드 사용하고, 출시 후에는 token 사용 또는 외부 검색 기능 사용(algolia 등)으로 수정
    func filterPosts() {
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
