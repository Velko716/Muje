//
//  HomeView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var router: NavigationRouter
  @State private var viewModel = HomeViewModel()
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        TopNavigationView()
        List {
          ForEach(viewModel.postList, id: \.postId) { post in
            PostListItem(
              post: post,
              thumbnailImage: viewModel.thumbnailImages[post.postId]
            )
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle()) // 여백까지 터치 영역 확장
            .highPriorityGesture(
              TapGesture().onEnded {
                router.push(to: .RecruitmentDetailView(postId: post.postId.uuidString))
              }
            )
            .onAppear {
              if let lastIndex = viewModel.postList.lastIndex(where: { $0.postId == post.postId }),
                 lastIndex >= viewModel.postList.count - 5 {
                Task {
                  await viewModel.loadMorePosts()
                }
              }
            }
          }
          if viewModel.isLoadingMore {
            HStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          }
        } //: List
        .listStyle(.plain)
        .background(Color.clear)
        .refreshable {
          await viewModel.loadInitialPosts()
        }
      } //: VSTACK
      .padding(.horizontal, 16)
      PostCreateButton(action: {
        router.push(to: .uploadPostView)
      })
        .padding(.bottom, 24)
    } //: ZSTACK
    .task {
      if viewModel.postList.isEmpty {
        await viewModel.loadInitialPosts()
      }
    }
  }
}
