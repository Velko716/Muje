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
    @State var interviewSlotViewModel = InterviewSlotViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("면접 여부는 모집글 작성이 완려되면 수정할 수 없어요")
                .foregroundStyle(Color.gray)
            
            HStack {
                Button(action: {
                    postInterviewViewModel.hasInterview = true
                }, label: {
                    InterviewButton(condition: postInterviewViewModel.hasInterview, value: true, title: "예")
                })
                Spacer()
                Button(action: {
                    postInterviewViewModel.hasInterview = false
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
            
            CustomTextField(title: "면접 장소", tempTitle: "장소를 입력해주세요", textValue: $postInterviewViewModel.interviewLocation, subTitle: "추후 설정 가능", maxLength: 100)
        }
    }
}


#Preview {
    PostInterviewView(postInfoViewModel: .init(), postInterviewViewModel: .init())
}
