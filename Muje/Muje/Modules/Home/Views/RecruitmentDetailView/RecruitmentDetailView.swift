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
      ScrollView {
        ImageView(postImage: viewModel.postImages)
        RecruitmentDataView(postId: postId, viewModel: viewModel)
      }
      TopButtonView {
        // 네비게이션 연결
      }
    }
    .task {
      await viewModel.loadPostDetail(for: postId)
    }
    .navigationBarBackButtonHidden()
    .ignoresSafeArea(.all, edges: .top)
    
    BottomButtonView {
      guard let post = viewModel.post else {
        print("지원서에 전달 할 post 정보를 가져오지 못했습니다.")
        return
      }
      router.push(
        to: .ApplicationFormView(
          postId: postId,
          requirementFlags: RequirementFlags(from: post)
        )
      )
    }
  }
}

// MARK: - 로딩중 화면 어떻게할지 얘기해봐야함. 아직 적용한 코드는 아닙니다
extension RecruitmentDetailView {
  private var loadingView: some View {
    VStack {
      ProgressView()
        .scaleEffect(1.5)
      Text("이미지 불러오는 중...")
        .font(.headline)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
  }
}

#Preview {
  RecruitmentDetailView(postId: "")
}
