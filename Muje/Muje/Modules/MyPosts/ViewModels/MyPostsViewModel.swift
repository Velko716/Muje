//
//  MyPostsViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//
import SwiftUI

@Observable
class MyPostsViewModel {
    var recruitmentLists: [InterviewSlotModel] = [] //이후에 서버에서 받아오도록 변경_다가오는 일정에서 활용
    var applicationLists: [InterviewSlotModel] = [] //이후에 서버에서 받아오도록 변경_다가오는 일정에서 활용
    var recruitPosts: [PostModel] = [] //이후에 서버에서 받아오도록 변경_내가 올린 공고에 활용
    var applyPosts: [PostModel] = [] //이후에 서버에서 받아오도록 변경_내가 지원한 공고에 활용
    var isRecruit: Bool = false //모달 시트_다가오는 일정
    var isApply: Bool = false //모달 시트_다가오는 일정
    
    var currentRecruitPage: Int = 0
    var currentApplyPage: Int = 0
  
  
  // MARK: - 파베 관련
  private let firebaseAuthManager = FirebaseAuthManager.shared
  private let firestoreManager = FirestoreManager.shared
  
  // MARK: 현재 유저 ID
  var currentUserId: String? {
    guard let currentUser = firebaseAuthManager.currentUser else { return nil }
    
    return currentUser.userId
  }
  
  // MARK: 현재 유저의 지원 데이터
  var currentUserApplication: [Application] = []
  
  // MARK: 올린 공고에 대한 저장 변수
  var uploadPost: [Post] = []
  var uploadPostImage: [PostImage] = []
  var uploadPostSlot: [InterviewSlot] = []
  
  // MARK: 지원한 공고에 대한 저장 변수
  var applicationPost: [Post] = []
  var applicationPostImage: [PostImage] = []
  var applicationSlot: [InterviewSlot] = []
    
    func upcomingRecruitLists() -> [InterviewSlotModel] {
        let upcomingDates = recruitmentLists.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewDate && slot.interviewDate <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewDate < $1.interviewDate})
    
        return upcomingDates
    }
    
    func upcomingApplyLists() -> [InterviewSlotModel] {
        let upcomingDates = applicationLists.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewTime && slot.interviewTime <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewTime < $1.interviewTime})
        return upcomingDates
    }
    
    //다가오는 일정에서 포맷 확인 함수
    func checkFirst(lists: [InterviewSlotModel], index: Int) -> Bool {
        if index < 1 {
            return true
        } else {
            if lists[index - 1].interviewDate.dateString == lists[index].interviewDate.dateString {
                return false
            } else {
                return true
            }
        }
    }
}
// MARK: - 파이어베이스 로직
extension MyPostsViewModel {
  
}
// MARK: - 조건 쿼리문
private extension MyPostsViewModel {
  func currentUserApplication(
    for currentUserId: String
  ) async throws -> [Application] {
    return try await firestoreManager.fetchWithCondition(
      from: .applications,
      whereField: "applicant_user_id",
      equalTo: currentUserId,
      sortedBy: {
        $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date()
      }
    )
  }
  
  func fetchPost(for currentUserId: String) async throws -> [Post] {
    return try await firestoreManager.fetchWithCondition(
      from: .posts,
      whereField: "author_user_id",
      equalTo: currentUserId,
      sortedBy: {
        $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date()
      }
    )
  }
  
  func fetchInterviewSlot(for postId: String) async throws -> [InterviewSlot] {
    return try await firestoreManager.fetchWithCondition(
      from: .interviewSlots,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.interviewDate.dateValue() < $1.interviewDate.dateValue() }
    )
  }
  
}
