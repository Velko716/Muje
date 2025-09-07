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
  @EnvironmentObject private var globalUIState: GlobalUIState
  
  let postId: String
  
  var body: some View {
    ZStack {
      
      contentView

      TopButtonView(
        isAuthor: viewModel.isAuthor,
        action: { router.pop() },
        fixAction: {
          guard let post = viewModel.post else { return }
          router.push(to: .editContentView(post: post, postImages: viewModel.postImages))
          
        },
        reportAction: {}, // TODO: 신고하기
        deleteAction: { Task { await viewModel.deletePostInfo(for: postId) } }
      )
    }
    .onChange(of: viewModel.showAlert) {
      if viewModel.showAlert {
        router.popToRootView()
      }
    }
    .onChange(of: globalUIState.showEditToast, { oldValue, newValue in
      if newValue {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          globalUIState.showEditToast = false
        }
      }
    })
    .task {
      await viewModel.loadPostDetail(for: postId)
      await viewModel.preloadImageURL()
    }
    .toast(
      isShown: $globalUIState.showEditToast,
      message: "공고가 수정 되었어요",
      alignment: .bottom
    )
    .navigationBarBackButtonHidden()
    .ignoresSafeArea(.all, edges: .top)
    .loadingOverlay(
      viewModel.isLoading,
      message: viewModel.loadingMessage.title
    )
  }
  
  private var contentView: some View {
    VStack {
        ScrollView {
        ImageView(
          viewModel: viewModel,
          postImage: viewModel.postImages
        )
        .padding(.bottom, 24)
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
        to: .applicationFormView(
          postId: postId,
          requirementFlags: RequirementFlags(from: post),
          postBasicInfo: PostBasicInfo(from: post)
        )
      )
    } contactAction: {
      // TODO: 쪽지하기
    }
  }
}

enum loadingCase {
  case loadRecruitment
  case loadDelete
  
  var title: String {
    switch self {
    case .loadRecruitment:
      return "모집글 상세 데이터 불러오는 중..."
    case .loadDelete:
      return "삭제 중..."
    }
  }
}

#Preview {
  RecruitmentDetailView(postId: "mock_id")
    .environmentObject(NavigationRouter())
    .environmentObject(GlobalUIState())
}
