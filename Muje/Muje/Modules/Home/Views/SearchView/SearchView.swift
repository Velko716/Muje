//
//  SearchView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: NavigationRouter
    @State private var viewModel = SearchViewModel()
    @FocusState var isSearchBarFocused: Bool
    
    var body: some View {
        
        VStack {
            SearchBar(searchText: $viewModel.searchText, status: $viewModel.searchState, isTextFieldFocused: _isSearchBarFocused)
                .focused($isSearchBarFocused)
                .padding(.horizontal, 8)
                .onChange(of: viewModel.searchText) {
                    viewModel.updateSuggestions()
                    if viewModel.searchText.isEmpty {
                        viewModel.searchState = .typing
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if case .result = viewModel.searchState {
                        viewModel.searchState = .typing
                    }
                }
            //TODO: 검색 버튼 비활성화 구현
                .onSubmit {
                    guard !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                        return
                    }
                    viewModel.performSearch()
                    viewModel.searchState = .result(viewModel.searchText)
                }
            
            switch viewModel.searchState {
            case .typing:
                SearchSuggestionItemView(viewModel: viewModel)
            case .result(_):
                SearchResultView(viewModel: viewModel)
                    .onAppear {
                        isSearchBarFocused = false
                    }
            }
        } //: VSTACK
        .padding(.horizontal, 16)
        .onAppear {
            if viewModel.searchText == "" {
                isSearchBarFocused = true
            }
        }
    }
}
