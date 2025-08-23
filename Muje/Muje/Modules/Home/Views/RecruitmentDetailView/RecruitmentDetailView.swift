//
//  RecruitmentDetailView.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI

struct RecruitmentDetailView: View {
  
  @State private var viewModel = RecruitmentViewModel()
  @EnvironmentObject private var router: NavigationRouter
  
  let postId: String
  
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        loadingView
      } else {
        contentView
      }
      TopButtonView(isAuthor: viewModel.isAuthor) {
        router.pop()
      }
    }
    .task {
      await viewModel.loadPostDetail(for: postId)
    }
    .navigationBarBackButtonHidden()
    .ignoresSafeArea(.all, edges: .top)
    
    
    
  }
  
  private var contentView: some View {
    VStack {
      ScrollView {
        ImageView(postImage: viewModel.postImages)
        RecruitmentDataView(postId: postId, viewModel: viewModel)
      }
      if !viewModel.isAuthor { // 작성자가 아닐때 하단 버튼 표시
        bottomButtonArea
      }
    }
  }
  
  private var bottomButtonArea: some View {
    BottomButtonView(hasApplied: viewModel.hasApplied) {
      guard let post = viewModel.post else { return }
      router.push(
        to: .ApplicationFormView(
          postId: postId,
          requirementFlags: RequirementFlags(from: post),
          postBasicInfo: PostBasicInfo(from: post)
        )
      )
    } contactAction: {
      // 문의하기 뷰로 이동
    }
  }
}

// MARK: - 로딩중 화면 어떻게할지 얘기해봐야함. 아직 적용한 코드는 아닙니다
extension RecruitmentDetailView {
  private var loadingView: some View {
    VStack {
      ProgressView()
        .scaleEffect(1.5)
      Text("모집글 상세 데이터 불러오는 중...")
        .font(.headline)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
  }
}

#Preview {
  RecruitmentDetailView(postId: "mock_id")
    .environmentObject(NavigationRouter())
}
