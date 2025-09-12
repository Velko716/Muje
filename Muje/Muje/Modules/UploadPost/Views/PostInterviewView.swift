//
//  PostInterviewView.swift
//  Muje
//
//  Created by Air on 8/25/25.
//

import SwiftUI

struct PostInterviewView: View {
    @Bindable var postInfoViewModel: PostInfoViewModel
    @Bindable var postInterviewViewModel: PostInterviewViewModel
    @Bindable var interviewSlotViewModel: InterviewSlotViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("면접 여부는 모집글 작성이 완려되면 수정할 수 없어요")
                .caption14Medium()
                .foregroundStyle(.gray500)
            
            HStack {
                Button(action: {
                    if postInterviewViewModel.hasInterview == nil || postInterviewViewModel.hasInterview == false {
                        postInterviewViewModel.hasInterview = true
                    }
                    else {
                        postInterviewViewModel.hasInterview = nil // 버튼 한 번 더 클릭 시 선택 취소
                    }
                }, label: {
                    InterviewButton(condition: postInterviewViewModel.hasInterview, value: true, title: "예")
                })
                Spacer()
                Button(action: {
                    if postInterviewViewModel.hasInterview == nil || postInterviewViewModel.hasInterview == true {
                        postInterviewViewModel.hasInterview = false
                    }
                    else {
                        postInterviewViewModel.hasInterview = nil // 버튼 한 번 더 클릭 시 선택 취소
                    }
                }, label: {
                    InterviewButton(condition: postInterviewViewModel.hasInterview, value: false, title: "아니요")
                })
            }
            
            if let condition = postInterviewViewModel.hasInterview {
                if condition == true {
                    interviewSettingView
                }
            }
            
            Spacer()
            
        }
        .sheet(isPresented: $postInterviewViewModel.isSheet, content: {
            InterviewSlotView(postInfoViewModel: postInfoViewModel, postInterviewViewModel: postInterviewViewModel, interviewSlotViewModel: interviewSlotViewModel)
        })
    }
    
    private var interviewSettingView: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text("면접 일정")
                    Text("추후 설정 가능")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
                
                Button(action: {
                    print("데이트 피커")
                    postInterviewViewModel.isSheet.toggle()
                }, label: {
                    HStack(spacing: 6) {
                        Text(interviewSlotViewModel.datePrint())
                        Spacer()
                        Image(systemName: "calendar")
                    }
                    .foregroundStyle(Color.gray)
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                    )
                })
            }
            VStack(alignment: .leading, spacing: 8) {
                TextWithDescription(MainText: "면접 장소", Description: "추후 설정 가능")
                RoundedTextField(text: $postInterviewViewModel.interviewLocation, placeholder: "장소를 입력해주세요", keyboard: .default)
            }
        }
    }
}


#Preview {
  PostInterviewView(postInfoViewModel: .init(), postInterviewViewModel: .init(), interviewSlotViewModel: .init())
}
