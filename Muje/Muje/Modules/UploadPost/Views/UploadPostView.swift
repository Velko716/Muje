//
//  UploadPostView.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct UploadPostView: View {
    @EnvironmentObject private var router: NavigationRouter
    @State var uploadPostViewModel = UploadPostViewModel()
    @State var postInfoViewModel = PostInfoViewModel()
    @State var postInterviewViewModel = PostInterviewViewModel()
    @State var recruitmentPostViewModel = RecruitmentPostViewModel()
    @State var interviewSlotViewModel = InterviewSlotViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @State private var keyboardHandler = KeyboardResponder()
    
    var body: some View {
      
        ZStack(alignment: .bottom) {
          ScrollView {
            VStack(alignment: .leading) {
              StatusView(uploadPostViewModel: $uploadPostViewModel)
              
              Spacer()
              
              if uploadPostViewModel.currentStatus == .input {
                PostInfoView(
                  postInfoViewModel: postInfoViewModel
                )
                .focused($isTextFieldFocused)
                
              } else if uploadPostViewModel.currentStatus == .interview {
                PostInterviewView(
                  postInfoViewModel: postInfoViewModel,
                  postInterviewViewModel: postInterviewViewModel, interviewSlotViewModel: interviewSlotViewModel
                )
                .focused($isTextFieldFocused)
              } else {
                RecruitmentPostView(
                  viewModel: recruitmentPostViewModel
                )
                .focused($isTextFieldFocused)
              }
            }
            .safeAreaPadding(.horizontal, 16)
          }
          .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: keyboardHandler.currentHeight)
          }
          .onChange(of: postInfoViewModel.selectedItems) { old, new in
            postInfoViewModel.selectedImagesData.removeAll()
            if new.count == 5 {
              postInfoViewModel.showToast = true
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                postInfoViewModel.showToast = false
              }
            }
                Task {
                  let loadingTasks = new.map { item in
                    Task {
                      try? await item.loadTransferable(type: Data.self)
                    }
                  }
                  var imageData: [Data] = []
                  for task in loadingTasks {
                    if let data = await task.value {
                      imageData.append(data)
                    }
                  }
                  await MainActor.run {
                    postInfoViewModel.selectedImagesData = imageData
                  }
                }
          }
          .toast(isShown: $postInfoViewModel.showToast, message: "사진은 최대 5장까지만 업로드할 수 있어요", alignment: .bottom)
        }
        .safeAreaInset(edge: .bottom) {
            nextButtonView
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle("모임 올리기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                  if postInfoViewModel.title != "" || postInfoViewModel.content != "" ||
                      postInfoViewModel.organization != "" || !postInfoViewModel.selectedImagesData.isEmpty
                  {
                    uploadPostViewModel.isQuit = true
                  } else {
                    router.pop()
                  }
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.gray)
                })
            })
        }
        .sheet(isPresented: $uploadPostViewModel.isQuit) {
            AlertModalView(uploadPostViewModel: $uploadPostViewModel) {
                router.pop()
            }
        }
        .loadingOverlay(
            uploadPostViewModel.isLoading,
            message: "업로드 중..."
        )
        .overlay {
            if postInfoViewModel.isPicker {
                dateView
            }
        }
    }
    
    private var nextButtonView: some View {
        ZStack {
            if uploadPostViewModel.currentStatus == .input {
                Button(action: {
                    uploadPostViewModel.currentStatus = .interview
                    postInfoViewModel.debug()
                }, label: {
                    ActionButton(title: "다음", condition: postInfoViewModel.nextCheck())
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 43, trailing: 16))
                        .background(
                            Rectangle()
                                .fill(.graywhite)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4)
                        )
                })
                .disabled(postInfoViewModel.nextCheck())
            } else if uploadPostViewModel.currentStatus == .interview {
                TwoActionBottomButton(
                    leftAction: { uploadPostViewModel.currentStatus = .input },
                    leftText: "이전",
                    rightAction: {
                        uploadPostViewModel.currentStatus = .info
                    },
                    rightText: "다음",
                    nextButtonCondition: postInterviewViewModel.nextCheck()
                )
            } else {
                TwoActionBottomButton(
                    leftAction: { uploadPostViewModel.currentStatus = .interview
                    },
                    leftText: "이전",
                    rightAction: {
                        Task {
                            try await uploadPostViewModel.submit(
                                postInfo: postInfoViewModel,
                                requireInfo: recruitmentPostViewModel,
                                postInterviewViewModel: postInterviewViewModel,
                                interviewSlotViewModel: interviewSlotViewModel
                            )
                            router.push(to: .uploadCompleteView)
                        }
                    },
                    rightText: "모집글 올리기",
                    nextButtonCondition: !recruitmentPostViewModel.nextCheck()
                )
            }
        }
    }
    
    private var dateView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    postInfoViewModel.isPicker = false
                }
            DatePicker("", selection: $postInfoViewModel.endDate, in: postInfoViewModel.dateRange, displayedComponents: .date)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .offset(y: 12)
                        .onTapGesture {}
                })
                .datePickerStyle(.graphical)
                .onChange(of: postInfoViewModel.endDate, {
                    postInfoViewModel.connectDate()
                })
                .padding(.horizontal, 24)
                .zIndex(999)
        }
//        .zIndex(1)
        .ignoresSafeArea()
        .task {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    UploadPostView()
}
