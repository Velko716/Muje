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
    var isLoading: Bool = false
    
    var currentRecruitPage: Int = 0
    var currentApplyPage: Int = 0
  
  
  // MARK: - 파베 관련
  private let firebaseAuthManager = FirebaseAuthManager.shared
  private let firestoreManager = FirestoreManager.shared
  
  // MARK: 현재 유저 ID
//  var currentUserId: String? {
//    guard let currentUser = firebaseAuthManager.currentUser else { return nil }
//    
//    return currentUser.userId
//  }
  
  private let currentUserId: String? = "0062C371-34F5-470B-BFE1-F671E23C5C97"

  
  // MARK: 현재 유저의 지원 데이터
  var currentUserApplication: [UUID: Application] = [:]
  
  // MARK: 올린 공고에 대한 저장 변수
  var uploadPost: [Post] = []
  var uploadPostSlot: [UUID: [InterviewSlot]] = [:]
  var uploadThumbnail: [UUID: PostImage] = [:]
  
  // MARK: 지원한 공고에 대한 저장 변수
  var applicationPost: [Post] = []
  var applicationSlot: [UUID: [InterviewSlot]] = [:]
  var applicationThumbnail: [UUID: PostImage] = [:]
    
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
  // MARK: 모든 데이터 병렬 함수
  func loadAllData() async {
    isLoading = true
    defer { isLoading = false }
    
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        await self.loadApplicationData()
      }
      group.addTask {
        await self.loadUploadData()
      }
    }
  }
  // MARK: 현재 유저의 지원정보 로드 함수
  func loadApplicationData() async {
    guard let userId = currentUserId else { return }
    
    do {
      let app = try await currentUserApplication(for: userId)
      self.currentUserApplication = mapDicApp(for: app)
      
      await withTaskGroup(of: Void.self) { group in
        for i in app {
          group.addTask {
            do {
              guard let postId = UUID(uuidString: i.postId) else { return }
              let post = try await self.fetchApplicationPost(for: postId)
              
              await MainActor.run {
                self.applicationPost = post
              }
              
            } catch {
              print("\(userId)가 지원한 공고 정보 불러오기 실패")
            }
          }
          group.addTask {
            do {
              let slot = try await self.fetchInterviewSlot(for: i.postId)
              
              await MainActor.run {
                self.applicationSlot = self.mapDicSlot(for: slot)
              }
              
            } catch {
              print("\(userId)가 지원한 인터뷰 슬롯 불러오기 실패")
            }
          }
          group.addTask {
            do {
              let postIds: [UUID] = app.compactMap {
                UUID(
                  uuidString: $0.postId
                )
              }
              let thumb = try await self.firestoreManager.fetchThumbnailsForPost(for: postIds)
              
              await MainActor.run {
                self.applicationThumbnail = thumb
              }
            } catch {
              print("\(userId)가 지원한 공고의 썸네일 불러오기 실패 \(error)")
            }
          }
        }
      }
    } catch {
      print("현재 \(userId)의 Application 정보 불러오기 실패")
    }
  }
  // MARK: 내가 올린 공고 로드 함수
  func loadUploadData() async {
    guard let userId = currentUserId else { return }
    
    do {
      let posts = try await fetchPost(for: userId)
      self.uploadPost = posts
      
      await withTaskGroup(of: Void.self) { group in
        for post in posts {
          group.addTask {
            do {
              let slots = try await self.fetchInterviewSlot(for: post.postId.uuidString)
              await MainActor.run {
                self.uploadPostSlot = self.mapDicSlot(for: slots)
              }
            } catch {
              print("\(post.postId)의 인터뷰 슬롯 불러오기 실패 \(error)")
            }
          }
          group.addTask {
            do {
              let postId = posts.compactMap { $0.postId }
              let thumb = try await self.firestoreManager.fetchThumbnailsForPost(for: postId)
              
              await MainActor.run {
                self.uploadThumbnail = thumb
              }
              
            } catch {
              print("썸네일 불러오기 실패: \(error)")
            }
          }
        }
      }
    } catch {
      print("내가 올린 공고 로드 실패 \(error)")
    }
  }
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
  
  func fetchApplicationPost(for postId: UUID) async throws -> [Post] {
    return try await firestoreManager.fetchWithCondition(
      from: .posts,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: {
        $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date()
      }
    )
  }
  // MARK: - 딕셔너리 변환 함수
  func mapDicSlot(for slots: [InterviewSlot]) -> [UUID: [InterviewSlot]] {
    var slotDic: [UUID: [InterviewSlot]] = [:]
    
    for slot in slots {
      guard let postId = UUID(uuidString: slot.postId) else { continue }
      
      if slotDic[postId] == nil {
        slotDic[postId] = []
      }
      slotDic[postId]?.append(slot)
    }
    
    return slotDic
  }
  
  func mapDicApp(for apps: [Application]) -> [UUID: Application] {
    var appDic: [UUID: Application] = [:]
    
    for app in apps {
      guard let postId = UUID(uuidString: app.postId) else { continue }
      
      appDic[postId] = app
    }
    
    return appDic
  }
}
