//
//  UploadPostView.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

import SwiftUI

struct UploadPostView: View {
    @EnvironmentObject private var router: NavigationRouter
    @State var uploadPostViewModel = UploadPostViewModel()
    @State var postInfoViewModel = PostInfoViewModel()
    @State var postInterviewViewModel = PostInterviewViewModel()
    @State var recruitmentPostViewModel = RecruitmentPostViewModel()
    @State var interviewSlotViewModel = InterviewSlotViewModel()
  
    
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
              } else if uploadPostViewModel.currentStatus == .interview {
                PostInterviewView(
                  postInfoViewModel: postInfoViewModel,
                  postInterviewViewModel: postInterviewViewModel, interviewSlotViewModel: interviewSlotViewModel
                )
              } else {
                RecruitmentPostView(
                  viewModel: recruitmentPostViewModel
                )
              }
            }
            .safeAreaPadding(.horizontal, 16)
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
          nextButtonView
          
          if postInfoViewModel.isPicker {
            dateView
          }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("모임 올리기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading, content: {
            Button(action: {
              uploadPostViewModel.isQuit = true
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
    }
    
    private var nextButtonView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 120)
                .border(Color.gray.opacity(0.2))
            
            if uploadPostViewModel.currentStatus == .input {
                Button(action: {
                    uploadPostViewModel.currentStatus = .interview
                    postInfoViewModel.debug()
                }, label: {
                    ActionButton(title: "다음", condition: postInfoViewModel.nextCheck())
                        .hvPadding(16, 20)
                })
                .disabled(postInfoViewModel.nextCheck())
                
            } else if uploadPostViewModel.currentStatus == .interview {
                HStack {
                    Button(action: {
                        uploadPostViewModel.currentStatus = .input
                    }, label: {
                        ActionButton(title: "이전", condition: true)
                    })
                    Spacer()
                    Button(action: {
                        uploadPostViewModel.currentStatus = .info
                    }, label: {
                        ActionButton(title: "다음", condition: postInterviewViewModel.nextCheck())
                    })
                    .disabled(postInterviewViewModel.nextCheck())
                }
                .hvPadding(16, 20)
            } else {
              HStack {
                  Button(action: {
                      uploadPostViewModel.currentStatus = .interview
                  }, label: {
                      ActionButton(title: "이전", condition: true)
                  })
                  Spacer()
                Button(
                  action: {
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
                  label: {
                      ActionButton(title: "모집글 올리기", condition: true)
                  })
              }
              .hvPadding(16, 20)
            }
        }
    }
    
    private var dateView: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .ignoresSafeArea()
                .onTapGesture {
                    postInfoViewModel.isPicker = false
                }
            
            DatePicker("", selection: $postInfoViewModel.endDate, in: postInfoViewModel.dateRange, displayedComponents: .date)
                .background(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .offset(y: 12)
                })
                .datePickerStyle(.graphical)
                .onChange(of: postInfoViewModel.endDate, {
                    postInfoViewModel.connectDate()
                })
                .padding(.horizontal, 24)
        }
        .ignoresSafeArea()
    }
}



#Preview {
    UploadPostView()
}
