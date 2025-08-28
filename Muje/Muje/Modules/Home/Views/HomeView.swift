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
    VStack(alignment: .center) {
      HStack {
        Text("oo대학교 구인공고")
          .font(.system(size: 22))
        Spacer()
        
        //MARK: 검색 아이콘
        Button(action: {
          router.push(to: .searchView)
        }) {
          Image(systemName: "magnifyingglass")
        }
        
        //MARK: 알림 아이콘
        Button(action: {
          router.push(to: .notificationView)
        }) {
          Image(systemName: "bell")
        }
        
        //MARK: 설정 아이콘
        Button(action: {
          router.push(to: .notificationView) // 나중에 설정뷰로 수정
        }) {
          Image(systemName: "gearshape")
        }
      } //: HSTACK
      .padding(.horizontal, 16)
      
    } //: VSTACK
    ZStack(alignment: .bottom) {
      if viewModel.isLoading {
        Text("불러오는 중...")
          .frame(maxHeight: .infinity)
      }
      else {
        List {
          ForEach(viewModel.postList, id: \.postId) { post in
            PostListItem(
              post: post,
              thumbnailImage: viewModel.thumbnailImages[post.postId]
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle()) // 여백까지 터치 영역 확장
            .onTapGesture {
              router.push(to: .RecruitmentDetailView(postId: post.postId.uuidString))
            }
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
        .refreshable {
          await viewModel.loadInitialPosts()
        }
      }
      
      PostCreateButton()
        .padding(.bottom, 24)
    } //: ZSTACK
    .task {
      if viewModel.postList.isEmpty {
        await viewModel.loadInitialPosts()
      }
    }
  }
}
