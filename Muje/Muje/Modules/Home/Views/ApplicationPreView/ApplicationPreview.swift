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
        title: "지원서 미리보기") {
          router.pop()
        }
    ScrollView {
      
      userInfoSection
      
      userInfoDetailSection
      
      customQuestionSection
      
    }
  }
    .task {
      await viewModel.loadUserData(userId: postId)
    }
    
    bottomButtonSection
    
  }
  
  private var userInfoSection: some View {
    VStack(alignment: .leading) {
      Text(viewModel.userInfo?.name ?? "")
      
      HStack {
        if requirementFlags.requiresGender {
          Text(viewModel.userInfo?.genderDisplay ?? "")
        }
        if requirementFlags.requiresAge {
          Text(viewModel.userInfo?.ageString ?? "")
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 24)
    .padding(.vertical, 30)
  }
  
  private var userInfoDetailSection: some View {
    VStack(spacing: 5) {
      if requirementFlags.requiresPhone {
        //InfoRow(title: "연락처", value: viewModel.userInfo?.phone ?? "")
      }
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

#Preview {
  @Previewable @State var viewModel = ApplicationPreviewModel()
    
  return ApplicationPreview(
    postId: "",
    requirementFlags: RequirementFlags(
      from: Post(
        postId: UUID(),
        authorUserId: "",
        title: "ddddd",
        organization: "dddddd",
        content: "ddddddd",
        recruitmentStart: Timestamp(date: Date()),
        recruitmentEnd: Timestamp(date: Date()),
        hasInterview: true,
        status: PostStatus.recruiting.rawValue,
        requiresName: true,
        requiresStudentId: true,
        requiresDepartment: true,
        requiresGender: true,
        requiresAge: true,
        requiresPhone: true,
        authorName: "박기연",
        authorOrganization: "MAD"
      )
    ),
    postBasicInfo: PostBasicInfo(
      from: Post(
        postId: UUID(),
        authorUserId: "",
        title: "ddddd",
        organization: "dddddd",
        content: "ddddddd",
        recruitmentStart: Timestamp(date: Date()),
        recruitmentEnd: Timestamp(date: Date()),
        hasInterview: true,
        status: PostStatus.recruiting.rawValue,
        requiresName: true,
        requiresStudentId: true,
        requiresDepartment: true,
        requiresGender: true,
        requiresAge: true,
        requiresPhone: true,
        authorName: "박기연",
        authorOrganization: "MAD"
      )
    ),
    customQuestion: [CustomQuestion(
      questionId: UUID(),
      postId: "",
      questionText: "햄버거 햄버거",
      questionOrder: 1
    ),CustomQuestion(
      questionId: UUID(),
      postId: "",
      questionText: "햄버거 햄버거",
      questionOrder: 2
    ),CustomQuestion(
      questionId: UUID(),
      postId: "",
      questionText: "햄버거 햄버거",
      questionOrder: 3
    ),CustomQuestion(
      questionId: UUID(),
      postId: "",
      questionText: "햄버거 햄버거",
      questionOrder: 4
    ),CustomQuestion(
      questionId: UUID(),
      postId: "",
      questionText: "햄버거 햄버거",
      questionOrder: 5
    )],
    questionAnswer: .constant(["" : "우아아아아ㅏㅇ아ㅏ아"])
  )
}
