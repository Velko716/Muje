//
//  UploadPostViewModel.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
final class UploadPostViewModel {
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firestoreManager = FirestoreManager.shared
  
    var currentUserId: String? {
      guard let currentUser = firebaseAuthManager.currentUser else { return nil }
    
      return currentUser.userId
    }
  
    var currentStatus: UploadPostStatus = .input
    var isQuit: Bool = false
    var alertContents: [String] = ["지금까지 작성한 내용이 저장되지 않습니다\n나가시겠어요?", "중단하고 나가기", "계속 작성하기"]
    var isLoading: Bool = false
  
  // MARK: - 파이어베이스 업로드
  func submit(
    postInfo: PostInfoViewModel,
    requireInfo: RecruitmentPostViewModel
  ) async throws {
    isLoading = true
    defer { isLoading = false }
    
    let postId = UUID()
    
    do {
      try await withThrowingTaskGroup(of: Void.self) { group in
        group.addTask {
          await self.createPost(
            postId: postId,
            postInfo: postInfo,
            requireInfo: requireInfo
          )
          print("\(postId) 공고 정보 생성 완료")
        }
        group.addTask {
          await self.createCustomQuestion(
            for: postId.uuidString,
            requireInfo: requireInfo
          )
          print("\(postId) 커스텀 질문 목록 생성 완료")
        }
        try await group.waitForAll()
      }
    } catch {
      print("공고 작성 오류 발생")
    }
  }
  
  // MARK: POST 생성
  func createPost(
    postId: UUID,
    postInfo: PostInfoViewModel,
    requireInfo: RecruitmentPostViewModel
  ) async {
    
    do {
      let post = Post(
        postId: postId,
        authorUserId: currentUserId ?? "",
        title: postInfo.title,
        organization: postInfo.organization,
        content: postInfo.content,
        recruitmentStart: Timestamp(date: postInfo.startDate),
        recruitmentEnd: Timestamp(date: postInfo.endDate),
        hasInterview: true,
        interviewLocation: nil,
        status: PostStatus.recruiting.rawValue,
        requiresName: true,
        requiresStudentId: requireInfo.basicInfoChecked[.studentId] ?? false,
        requiresDepartment: requireInfo.basicInfoChecked[.major] ?? false,
        requiresGender: requireInfo.basicInfoChecked[.gender] ?? false,
        requiresAge: requireInfo.basicInfoChecked[.age] ?? false,
        requiresPhone: false,
        authorName: firebaseAuthManager.currentUser?.name ?? "",
        authorOrganization: postInfo.organization
      )
      
      _ = try await firestoreManager.create(post)
      
    } catch {
      print("공고 정보 생성 실패")
    }
  }
  
  // MARK: CustomQuestion 생성
  func createCustomQuestion(
    for postId: String,
    requireInfo: RecruitmentPostViewModel
  ) async {
    
    do {
      let ques = requireInfo.createCustomQuestion(for: postId)
      
      for que in ques {
        _ = try await firestoreManager.create(que)
      }
    } catch {
      print("커스텀 질문 목록 생성 실패")
    }
  }
  
  // MARK: InterviewSlot 생성
  
}
