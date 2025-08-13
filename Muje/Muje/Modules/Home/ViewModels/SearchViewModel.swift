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
    var isTyping: Bool = false
    var allPosts: [Post] = []
    var cancellables = Set<AnyCancellable>()
    var searchResults: [Post] = []
    var errorMessage: String?
    
    private var db = Firestore.firestore()
    
    init() {
        //휴
    }
    
    func setPosts(_ posts: [Post]) {
        allPosts = posts
        errorMessage = nil
        
        if !searchText.isEmpty {
            filterPosts(with: searchText)
        }
    }
    
    func filterPosts(with searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            isTyping = false
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
    
    func updateSearchResults(results: [Post]) {
        self.searchResults = results
    }
    
    
    //MARK: 검색 내용 초기화 함수
    func clearSearch() {
        searchText = ""
    }
}
