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

@Observable
final class SearchViewModel {
    var searchText: String = ""
    var isTyping: Bool = false
    var searchResults: [Post] = []
    var errorMessage: String?
    
    private var db = Firestore.firestore()
    
    init() {
        //어떤 내용을 넣어야 할지 모르겠어요ㅠ
    }
    
    func search(for query: String) async -> [Post] {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return [
            
        ]
    }
    
    func updateSearchResults(results: [Post]) {
        self.searchResults = results
    }
}
