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
  
  var body: some View {
    
    VStack {
      SearchBar(searchText: $viewModel.searchText, status: $viewModel.searchState)
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
      }
    } //: VSTACK
    .padding(.horizontal, 16)
  }
}
