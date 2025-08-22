//
//  ApplicationPreviewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import Foundation
import FirebaseFirestore

@Observable
final class ApplicationPreviewModel {
  
  private let firesotreManager = FirestoreManager.shared
  
  var userInfo: User?
  
  func loadUserData(userId: String) async {
    do {
      guard let userID = UUID(uuidString: userId) else {
        print("UUID 바꾸기 실패")
        return
      }
      
      let info: User = try await firesotreManager.get(
        userID.uuidString,
        from: .user
      )
      self.userInfo = info
      
    } catch {
      print("지원서 작성: 유저 정보 불러오기 실패")
    }
  }
  
  func submitApplication(
    postId: String,
    post: PostBasicInfo,
    requirement: RequirementFlags,
    questionAnswer: [String: String],
    customQuestion: [CustomQuestion]
  ) async throws {
    
    guard let userInfo = userInfo else { return }
    
    let savedApplication = try await saveApplication(
      userInfo: userInfo,
      postId: postId,
      post: post,
      requirement: requirement
    )
    
    try await saveQuestionAnswer(
      customQuestion: customQuestion,
      questionAnswer: questionAnswer,
      applicationId: savedApplication.applicationId.uuidString
    )
    print("지원서 제출 성공")
  }
  
  
  private func saveApplication(
    userInfo: User,
    postId: String,
    post: PostBasicInfo,
    requirement: RequirementFlags
  ) async throws -> Application {
    
    let application = createApplication(
      userInfo: userInfo,
      postId: postId,
      post: post,
      requirement: requirement
    )
    
    return try await firesotreManager.create(application)
  }
  
  private func saveQuestionAnswer(
    customQuestion: [CustomQuestion],
    questionAnswer: [String: String],
    applicationId: String
  ) async throws {
    
    let questionAnswers = createQuestionAnswer(
      customQuestion: customQuestion,
      questionAnswer: questionAnswer,
      applicationId: applicationId
    )
    
    for questionAnswer in questionAnswers {
      _ = try await firesotreManager.create(questionAnswer)
    }
  }
  
  private func createApplication(
    userInfo: User,
    postId: String,
    post: PostBasicInfo,
    requirement: RequirementFlags
  ) -> Application {
    
    return Application(
      applicationId: UUID(),
      applicantUserId: userInfo.userId,
      postId: postId,
      status: ApplicationStatus.submitted.rawValue,
      isPassed: nil,
      interviewSlotId: nil,
      interviewReservationStatus: nil,
      applicantName: userInfo.name,
      applicantBirthYear: requirement.requiresAge ? userInfo.birthYear : nil,
      applicantGender: requirement.requiresGender ? userInfo.gender : nil,
      applicantDepartment: requirement.requiresDepartment ? userInfo.department : nil,
      applicantStudentId: requirement.requiresStudentId ? userInfo.studentId : nil,
      postTitle: post.title,
      postOrganization: post.organization,
      postAuthorUserId: post.authorUserId
    )
  }
  
  private func createQuestionAnswer(
    customQuestion: [CustomQuestion],
    questionAnswer: [String: String],
    applicationId: String
  ) -> [QuestionAnswer] {
    
    return customQuestion.compactMap { question in
      guard let userAnswer = questionAnswer[question.questionId.uuidString],
            !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        return nil
      }
      
      return QuestionAnswer(
        answerId: UUID(),
        applicationId: applicationId,
        questionId: question.questionId.uuidString,
        questionText: question.questionText,
        answerText: userAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
      )
    }
  }
}
