//
//  ApplicationPreview.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI
import FirebaseFirestore

struct ApplicationPreview: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    let postId: String // 키체인 구현전까지 테스트용으로 userId로 같이 씀.
    let requirementFlags: RequirementFlags
    let postBasicInfo: PostBasicInfo
    let customQuestion: [CustomQuestion]
    @Binding var questionAnswer: [String: String]
    
    @State private var viewModel = ApplicationPreviewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "신청서 미리보기") {
                    router.pop()
                }
            ScrollView {
                
                userInfoSection
                Spacer().frame(height: 24)
                userInfoDetailSection
                Spacer().frame(height: 24)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 12)
                    .foregroundStyle(Color.gray.opacity(0.2)) //TODO: divider 컴포넌트로 변경
                Spacer().frame(height: 24)
                customQuestionSection
                
            }
        }
        .task {
            await viewModel.loadUserData(userId: postId)
        }
        
        bottomButtonSection
        
    }
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.userInfo?.name ?? "")
                .headline24SemiBold()
            
            HStack(spacing: 0) {
                if requirementFlags.requiresGender && requirementFlags.requiresAge {
                    Text(viewModel.userInfo?.genderDisplay ?? "")
                        .body2Regular16()
                        .foregroundStyle(.gray800)
                    Text(", ")
                        .body2Regular16()
                        .foregroundStyle(.gray800)
                    Text(viewModel.userInfo?.ageString ?? "")
                        .body2Regular16()
                        .foregroundStyle(.gray800)
                }
                else if requirementFlags.requiresGender && !requirementFlags.requiresAge {
                    Text(viewModel.userInfo?.genderDisplay ?? "")
                        .body2Regular16()
                        .foregroundStyle(.gray800)
                }
                else if !requirementFlags.requiresAge && requirementFlags.requiresAge {
                    Text(viewModel.userInfo?.ageString ?? "")
                        .body2Regular16()
                        .foregroundStyle(.gray800)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var userInfoDetailSection: some View {
        VStack(spacing: 5) {
            if requirementFlags.requiresStudentId {
                InfoRow(title: "학번", value: viewModel.userInfo?.studentId ?? "")
            }
            if requirementFlags.requiresDepartment {
                InfoRow(title: "학과", value: viewModel.userInfo?.department ?? "")
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var customQuestionSection: some View {
        VStack {
            ForEach(customQuestion, id: \.questionId) { question in
                QuestionAnswerToggle(
                    question: question.questionText,
                    answer: questionAnswer[question.questionId.uuidString] ?? "답변이 입력되지 않았습니다."
                )
                if question.questionId != customQuestion.last?.questionId {
                    Divider()
                        .foregroundStyle(.gray50)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private var bottomButtonSection: some View {
        VStack {
            Button {
                Task {
                    try await viewModel.submitApplication(
                        postId: postId,
                        post: postBasicInfo,
                        requirement: requirementFlags,
                        questionAnswer: questionAnswer,
                        customQuestion: customQuestion
                    )
                }
            } label: {
                Text("확인")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
    }
}
