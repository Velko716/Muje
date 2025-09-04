//
//  EditContentView.swift
//  Muje
//
//  Created by 조재훈 on 8/24/25.
//

import SwiftUI
import FirebaseFirestore

struct EditContentView: View {
  @EnvironmentObject private var globalUIState: GlobalUIState
  @EnvironmentObject private var router: NavigationRouter
  @State private var viewModel: EditPostViewModel
  
  init(post: Post, postImages: [PostImage]) {
    self._viewModel = State(initialValue: EditPostViewModel(post: post, postImages: postImages))
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading) {
          EditPostView(viewModel: viewModel)
        }
        .safeAreaPadding(.horizontal, 16)
      }
      
      if viewModel.isPicker {
        dateView
      }
      
    }
    .safeAreaInset(edge: .bottom) {
      bottomButton
    }
  }
  
  private var dateView: some View {
    ZStack {
      Rectangle()
        .fill(Color.black.opacity(0.4))
        .ignoresSafeArea()
        .zIndex(0)
        .onTapGesture {
          viewModel.isPicker = false
        }
      
      DatePicker("", selection: $viewModel.endDate, in: viewModel.dateRange, displayedComponents: .date)
        .zIndex(1)
        .datePickerStyle(.graphical)
        .background(Color.white)
        .onChange(of: viewModel.endDate, {
          viewModel.isPicker = false
          viewModel.endDateString = viewModel.endDate.dateString
        })
        .padding(.horizontal, 24)
    }
    .ignoresSafeArea()
  }
  
  private var bottomButton: some View {
    VStack {
      Button {
        Task {
          await viewModel.updatedPost()
          router.pop()
          globalUIState.showEditToast = true
        }
      } label: {
        Text("수정 저장하기")
          .body1SemiBold18()
          .foregroundStyle(.white01)
          .padding()
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.primaryBlack)
          )
      }
    }
    .hvPadding(16, 20)
    .frame(maxWidth: .infinity)
    .background(
      Rectangle()
        .fill(Color.white)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .bottom)
    )
  }
}

#Preview {
  EditContentView(
    post: Post(
      postId: UUID(),
      authorUserId: "",
      title: "",
      organization: "",
      content: "",
      recruitmentStart: Timestamp(date: Date()),
      recruitmentEnd: Timestamp(date: Date()),
      status: PostStatus.recruiting.rawValue,
      authorName: "",
      authorOrganization: ""
    ),
    postImages: [PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0,
      createdAt: Timestamp(date: Date())
    )]
  )
  .environmentObject(GlobalUIState())
}
