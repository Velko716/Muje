//
//  SearchResultItemView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchResultView: View {
  @EnvironmentObject var router: NavigationRouter
  @Bindable var viewModel: SearchViewModel
  
  var body: some View {
    VStack {
      if viewModel.isSearching {
        HStack {
          ProgressView()
            .scaleEffect(0.75)
          Text("검색 중...")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      } else if viewModel.searchResults.isEmpty {
        Text("검색 결과가 없습니다.")
          .font(.headline)
          .foregroundStyle(.secondary)
      } else {
        List {
          ForEach(viewModel.searchResults, id: \.postId) { post in
            PostListItem(
              post: post,
              thumbnailImage: viewModel.thumbnailImages[post.postId]
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle()) // 여백까지 터치 영역 확장
            .highPriorityGesture(
              TapGesture().onEnded {
                router.push(to: .RecruitmentDetailView(postId: post.postId.uuidString))
              }
            )
          }
        }
        .listStyle(.plain)
      }
    } //: VSTACK
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
