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
  
  private let firestoreManager = FirestoreManager.shared
  
  var postImages: [PostImage] = []
  var isLoading: Bool = false
  var errorMessage: String?
  var showError: Bool = false
  
  var post: Post?
  var interviewSlots: [InterviewSlot] = []
  
  var interviewperiod: (start: Date, end: Date)? {
    guard !interviewSlots.isEmpty else { return nil }
    
    let dated = interviewSlots.map { $0.interviewDate.dateValue() }
    guard let minDate = dated.min(),
          let maxDate = dated.max() else { return nil }
    
    return (start: minDate, end: maxDate)
  }
  
  func loadPostDetail(for postId: String) async {
    isLoading = true
    
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        await self.loadPost(postId: postId)
      }
      group.addTask {
        await self.loadPostImage(for: postId)
      }
      group.addTask {
        await self.loadInterviewSlots(for: postId)
      }
    }
  }
  
  private func loadPost(postId: String) async {
    do {
      let loadPost: Post = try await firestoreManager.get(
        postId,
        from: .posts
      )
      self.post = loadPost
      
    } catch {
      self.errorMessage = "공고 정보를 불러올 수 없습니다."
      self.showError = true
      print("공고 정보 로드 실패")
    }
  }
  
  private func loadPostImage(for postId: String) async {
    do {
      let images = try await fetchPostImage(for: postId)
      self.postImages = images
      
    } catch {
      print("공고 이미지 로드 실패")
    }
  }
  
  private func loadInterviewSlots(for postId: String) async {
    do {
      let slots = try await fetchInterviewSlots(for: postId)
      self.interviewSlots = slots
      
    } catch {
      print("면접 슬롯 로드 실패")
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
}
