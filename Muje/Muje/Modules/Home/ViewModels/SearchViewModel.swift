//
//  SearchViewModel.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

//뷰모델에서 관리할 것 : 입력 상태, 검색어 타이핑한 거, 비동기 처리 필터링

import Foundation
import SwiftUI

@Observable
final class SearchViewModel {
    var searchText = ""
    var searchResults: [Post] = []
    var searchState: SearchStatus = .typing
    
    var thumbnailImages: [UUID: PostImage] = [:]
    
    
    // MARK: 서버 필터링
    private var suggestionTask: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?
    
    var suggestions: [PostSuggestion] = []
    var isSuggestionsLoading: Bool = false
    var isSearching: Bool = false
    
    @MainActor
    func updateSuggestions() {
        suggestionTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            suggestions = []
            return
        }
        
        suggestionTask = Task {
            try? await Task.sleep(for: .seconds(0.3))
            
            guard !Task.isCancelled else { return }
            
            do {
                await MainActor.run { self.isSuggestionsLoading = true }
                
                let results = try await FirestoreManager.shared.searchSuggestions(query: query)
                
                await MainActor.run {
                    if !Task.isCancelled {
                        self.suggestions = results
                    }
                    self.isSuggestionsLoading = false
                }
            } catch {
                await MainActor.run {
                    print("자동완성 실패")
                    self.isSuggestionsLoading = false
                }
            }
        }
    }
    
    @MainActor
    func performSearch() {
        searchTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return }
        
        searchTask = Task {
            do {
                await MainActor.run { self.isSearching = true }
                
                let(posts, thum) = try await FirestoreManager.shared.searchPosts(query: query)
                
                await MainActor.run {
                    if !Task.isCancelled {
                        self.searchResults = posts
                        self.thumbnailImages = thum
                    }
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    print("상세 검색 실패 \(error)")
                    self.isSearching = false
                }
            }
        }
    }
    
    func highlightedOrgText(_ text: String, keyword: String) -> AttributedString {
        return createHighlightedText(
            text: text,
            keyword: keyword,
            normalFont: .pretendard(type: .regular, size: 14),
            highlightFont: .pretendard(type: .semiBold, size: 14)
        )
    }
    
    func highlightedTitleText(_ text: String, keyword: String) -> AttributedString {
        return createHighlightedText(
            text: text,
            keyword: keyword,
            normalFont: .pretendard(type: .medium, size: 16),
            highlightFont: .pretendard(type: .semiBold, size: 16)
        )
    }
    
    // 하이라이트 함수
    private func createHighlightedText(
        text: String,
        keyword: String,
        normalFont: Font,
        highlightFont: Font
    ) -> AttributedString {
        var attributed = AttributedString(text)
        
        // 전체 텍스트에 기본 스타일 적용
        attributed.font = normalFont
        
        // 검색어 하이라이트
        guard !keyword.isEmpty else { return attributed }
        
        let lowercasedText = text.lowercased()
        let lowercasedKeyword = keyword.lowercased()
        
        var searchStartIndex = lowercasedText.startIndex
        
        while let range = lowercasedText.range(of: lowercasedKeyword, range: searchStartIndex..<lowercasedText.endIndex) {
            if let attributedRange = Range(range, in: attributed) {
                // 하이라이트 스타일 적용
                attributed[attributedRange].font = highlightFont
                attributed[attributedRange].foregroundColor = .pointSkyBlue
                // 배경색을 원한다면:
                // attributed[attributedRange].backgroundColor = .yellow.opacity(0.3)
            }
            searchStartIndex = range.upperBound
        }
        
        return attributed
    }
}
