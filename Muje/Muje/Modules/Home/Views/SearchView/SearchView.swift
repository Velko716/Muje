//
//  SearchView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText, status: $viewModel.searchState)
                .padding(.horizontal, 8)
                .onChange(of: viewModel.searchText) {
                    viewModel.filterPosts()
                    viewModel.searchState = .typing
                }
                .onTapGesture {
                    if case .result = viewModel.searchState {
                        viewModel.searchState = .typing
                    }
                }
            //FIXME: 검색 버튼 비활성화 구현
            //지금은 입력 없으면 무시하는 형태로 구현 해두었습니다.ㅠㅠ
                .onSubmit {
                    guard !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                        // 입력이 없으면 그냥 무시
                        return
                    }
                    viewModel.searchState = .result(viewModel.searchText)
                }
            
            switch viewModel.searchState {
            case .typing:
                SearchSuggestionItemView(filteredPosts: $viewModel.searchResults)
            case .result(let keyword):
                SearchResultView(searchText: $viewModel.searchText, filteredPosts: $viewModel.searchResults)
            }
            
        } //: VSTACK
        
    }
    
    
}

#Preview {
    SearchView(viewModel: SearchViewModel())
        .environmentObject(NavigationRouter())
}
