//
//  UploadPostView.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

import SwiftUI

struct UploadPostView: View {
    @State var uploadPostViewModel = UploadPostViewModel()
    @State var postInfoViewModel = PostInfoViewModel()
    @State var postInterviewViewModel = PostInterviewViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading) {
                        StatusView(uploadPostViewModel: $uploadPostViewModel)
                        
                        Spacer()
                        
                        if uploadPostViewModel.currentStatus == .input {
                            PostInfoView(postInfoViewModel: postInfoViewModel)
                        } else if uploadPostViewModel.currentStatus == .interview {
                            PostInterviewView(postInfoViewModel: postInfoViewModel, postInterviewViewModel: postInterviewViewModel)
                        }
                        
                    }
                    .safeAreaPadding(.horizontal, 16)
                }
                
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
                AlertModalView(uploadPostViewModel: $uploadPostViewModel)
            }
        }
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
                        print("다음")
                        postInterviewViewModel.debug()
                    }, label: {
                        ActionButton(title: "다음", condition: postInterviewViewModel.nextCheck())
                    })
                    .disabled(postInterviewViewModel.nextCheck())
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
