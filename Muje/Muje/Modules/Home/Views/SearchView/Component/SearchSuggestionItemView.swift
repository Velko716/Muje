//
//  SearchSuggestionItem.swift
//  Muje
//
//  Created by 김서현 on 8/14/25.
//

import SwiftUI

struct SearchSuggestionItemView: View {
    @EnvironmentObject var router: NavigationRouter
    @Bindable var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            if viewModel.isSuggestionsLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.75)
                    Text("검색 중...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
            } else if viewModel.suggestions.isEmpty && !viewModel.searchText.isEmpty {
                Text("검색 결과가 없습니다.")
                    .subheadline22semibold()
                    .foregroundStyle(.gray600)
                
            } else {
                List {
                    ForEach(viewModel.suggestions, id: \.postId) { value in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.highlightedOrgText(value.organization, keyword: viewModel.searchText))
                            Text(viewModel.highlightedTitleText(value.title, keyword: viewModel.searchText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .highPriorityGesture(
                            TapGesture().onEnded {
                                router.push(to: .RecruitmentDetailView(postId: value.postId))
                            }
                        ) //ㅠㅠ x발~~
                    }
                }
                .listStyle(.plain)
                .padding(.vertical, 18)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

