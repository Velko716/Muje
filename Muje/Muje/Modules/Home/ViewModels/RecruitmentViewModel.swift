//
//  RecruitmentViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import Foundation
import FirebaseFirestore

@Observable
final class RecruitmentViewModel {
  
  private let firebaseAuthManager = FirebaseAuthManager.shared
  private let firestoreManager = FirestoreManager.shared
//  private let currentUserId: String = firebaseAuthManager.currentUser?.userId
  
  var currentUserId: String? {
    guard let currentUser = firebaseAuthManager.currentUser else { return nil }
    
    return currentUser.userId
  }
  
  var isLoading: Bool = false
  var loadingMessage: loadingCase = .loadRecruitment
  var showAlert: Bool = false
  var errorMessage: String?
  var showError: Bool = false
  
  var post: Post?
  var postImages: [PostImage] = []
  var interviewSlots: [InterviewSlot] = []
  
  var isAuthor: Bool = false // 작성자?
  var hasApplied: Bool = false // 지원여부?
  
  var interviewperiod: (start: Date, end: Date)? {
    guard !interviewSlots.isEmpty else { return nil }
    
    let dated = interviewSlots.map { $0.interviewDate.dateValue() }
    guard let minDate = dated.min(),
          let maxDate = dated.max() else { return nil }
    
    return (start: minDate, end: maxDate)
  }
  
  @MainActor var imageURLCache: [UUID: String] = [:]
  
  @MainActor
  func preloadImageURL() async {
    await withTaskGroup(of: (UUID, String?).self) { group in
      for image in postImages {
        if imageURLCache[image.imageId] == nil {
          group.addTask {
            do {
              let url = try await image.getDownloadURL()
              return (image.imageId, url)
            } catch {
              print("이미지 url 로드 실패")
              return (image.imageId, nil)
            }
          }
        }
      }
      for await (imageId, url) in group {
        if let url = url {
          imageURLCache[imageId] = url
        }
      }
    }
  }
  // MARK: - 지원 여부 확인
  @MainActor
  func checkIfApplied() async {
    
    do {
      let application: [Application] = try await firestoreManager.fetchWithCondition(
        from: .applications,
        whereField: "applicant_user_id",
        equalTo: currentUserId ?? "",
        sortedBy: { _, _ in true }
      )
      
      hasApplied = application.contains { $0.postId == post?.postId.uuidString }
      
    } catch {
      print("해당 공고에 대한 지원 여부 확인 실패 \(error)")
      hasApplied = false
    }
  }
  
  @MainActor
  func loadPostDetail(for postId: String) async {
    isLoading = true
    
    await loadPost(postId: postId)
    await checkIfApplied()
    
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        await self.loadPostImage(for: postId)
      }
      group.addTask {
        await self.loadInterviewSlots(for: postId)
      }
      isLoading = false
    }
  }
  
  @MainActor
  private func loadPost(postId: String) async {
    do {
      let loadPost: Post = try await firestoreManager.get(
        postId,
        from: .posts
      )
      self.post = loadPost
      // MARK: 공고 작성자인지 확인까지 로드할때 한번에
      self.isAuthor = (loadPost.authorUserId == currentUserId)
      
    } catch {
      self.errorMessage = "공고 정보를 불러올 수 없습니다."
      self.showError = true
      print("공고 정보 로드 실패")
    }
  }
  
  @MainActor
  private func loadPostImage(for postId: String) async {
    do {
      let images = try await fetchPostImage(for: postId)
      self.postImages = images
      
    } catch {
      print("공고 이미지 로드 실패")
    }
  }
  
  @MainActor
  private func loadInterviewSlots(for postId: String) async {
    do {
      let slots = try await fetchInterviewSlots(for: postId)
      self.interviewSlots = slots
      
    } catch {
      print("면접 슬롯 로드 실패")
    }
  }
  // MARK: - 모집자의 공고 삭제 로직
  @MainActor
  func deletePostInfo(for postId: String) async {
    isLoading = true
    loadingMessage = .loadDelete
    
    do {
      let images = try await fetchPostImage(for: postId)
      for _ in images {
        try await firestoreManager.delete(
          collectionType: .postImages,
          documentID: postId
        )
        print("\(postId)의 postImage 삭제 완료")
      }
      
      let slots = try await fetchInterviewSlots(for: postId)
      for _ in slots {
        try await firestoreManager.delete(
          collectionType: .interviewSlots,
          documentID: postId
        )
        print("\(postId)의 InterviewSlot 삭제 완료")
      }
      
      let application = try await fetchApplication(for: postId)
      for app in application {
        try await firestoreManager.delete(
          collectionType: .applications,
          documentID: postId
        )
        let ques = try await fetchQuestionAnswer(for: app.applicationId.uuidString)
        for que in ques {
          try await firestoreManager.delete(
            collectionType: .questionAnswers,
            documentID: que.applicationId
          )
          print("\(postId)의 QuestionAnswer 삭제 완료")
        }
        print("\(postId)의 Application 삭제 완료")
      }
      
      let customQuestion = try await fetchCustomQuestion(for: postId)
      for _ in customQuestion {
        try await firestoreManager.delete(
          collectionType: .customQuestions,
          documentID: postId
        )
        print("\(postId)의 CustomQuestion 삭제 완료")
      }
      
      try await firestoreManager.delete(
        collectionType: .posts,
        documentID: postId
      )
      print("공고 삭제 성공")
      
      isLoading = false
      loadingMessage = .loadRecruitment
      showAlert = true
    } catch {
      print("공고 삭제 실패")
      isLoading = false
      loadingMessage = .loadRecruitment
    }
  }
}

// MARK: - 조건 쿼리문
private extension RecruitmentViewModel {
  func fetchPostImage(for postId: String) async throws -> [PostImage] {
    return try await firestoreManager.fetchWithCondition(
      from: .postImages,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.imageOrder < $1.imageOrder }
    )
  }
  
  func fetchInterviewSlots(for postId: String) async throws -> [InterviewSlot] {
    return try await firestoreManager.fetchWithCondition(
      from: .interviewSlots,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.interviewDate.dateValue() < $1.interviewDate.dateValue() }
    )
  }
  
  func fetchApplication(for postId: String) async throws -> [Application] {
    return try await firestoreManager.fetchWithCondition(
      from: .applications,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date() }
    )
  }
  
  func fetchCustomQuestion(for postId: String) async throws -> [CustomQuestion] {
    return try await firestoreManager.fetchWithCondition(
      from: .customQuestions,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.questionOrder < $1.questionOrder }
    )
  }
  
  func fetchQuestionAnswer(for applicationId: String) async throws -> [QuestionAnswer] {
    return try await firestoreManager.fetchWithCondition(
      from: .questionAnswers,
      whereField: "application_id",
      equalTo: applicationId,
      sortedBy: { $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date() }
    )
  }
}
