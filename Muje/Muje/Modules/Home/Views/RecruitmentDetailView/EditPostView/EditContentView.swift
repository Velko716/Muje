//
//  EditContentView.swift
//  Muje
//
//  Created by 조재훈 on 8/24/25.
//

import SwiftUI
import FirebaseFirestore

struct EditContentView: View {
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
      bottomButton
      
      if viewModel.isPicker {
        dateView
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }
  
  private var dateView: some View {
    ZStack {
      Rectangle()
        .fill(Color.black.opacity(0.4))
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .zIndex(0)
      
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
      Spacer()
      Button {
        Task {
          await viewModel.updatedPost()
        }
      } label: {
        Text("수정 저장하기")
          .font(.system(size: 18))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .background(Color.black)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
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
}
