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
          .font(.subheadline)
          .foregroundStyle(.secondary)
        
      } else {
        List {
          ForEach(viewModel.suggestions, id: \.postId) { value in
            VStack(alignment: .leading, spacing: 4) {
              Text(value.organization)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
              Text(value.title)
                .font(.system(size: 16))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .highPriorityGesture(
              TapGesture().onEnded {
                router.push(to: .RecruitmentDetailView(postId: value.postId))
              }
            ) //ㅠㅠ x발~~
          }
        }
        .listStyle(.plain)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

