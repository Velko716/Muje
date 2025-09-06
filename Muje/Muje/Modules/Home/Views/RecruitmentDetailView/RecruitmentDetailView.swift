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
      if viewModel.isLoading {
        loadingView
      } else {
        contentView
      }
//      TopButtonView(isAuthor: viewModel.isAuthor) {
//        router.pop()
//      }
      TopButtonView(
        isAuthor: viewModel.isAuthor,
        action: { router.pop() },
        fixAction: {
          guard let post = viewModel.post else { return }
          router.push(to: .editContentView(post: post, postImages: viewModel.postImages))
          
        },
        reportAction: {}, // 신고하기 화면 이동
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
      Text(viewModel.loadingMessage.title)
        .font(.headline)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
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
