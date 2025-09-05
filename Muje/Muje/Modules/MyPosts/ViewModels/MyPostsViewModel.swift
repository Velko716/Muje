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
  
  // MARK: 캐싱 관련
  private var lastLoadTime: Date?
  private var isDataLoaded: Bool = false
  private let cacheValidDuration: TimeInterval = 300
  
  
  // MARK: - 캐시 함수
  // 캐시 유효한지 확인 (기준 5분)
  private var isCacheValid: Bool {
    guard let lastLoadTime = lastLoadTime else { return false }
    return Date().timeIntervalSince(lastLoadTime) < cacheValidDuration
  }
  // 캐시 상태 확인
  private func logCacheStatus() {
    if let lastLoadTime = lastLoadTime {
      let timeSinceLoad = Date().timeIntervalSince(lastLoadTime)
      print("마지막 로드: \(Int(timeSinceLoad))초 전, 캐시 유효함")
    } else {
      print("첫 로드")
    }
  }
  @MainActor
  func forceRefresh() async {
    print("새로 고침")
    currentRecruitPage = 0
    currentApplyPage = 0
    
    clearCache()
    await loadAllDataIfNeed(forceReload: true)
  }
  
  private func clearCache() {
    lastLoadTime = nil
    isDataLoaded = false
    
    currentUserApplication.removeAll()
    uploadPost.removeAll()
    uploadPostSlot.removeAll()
    uploadThumbnail.removeAll()
    applicationPost.removeAll()
    applicationSlot.removeAll()
    applicationThumbnail.removeAll()
    
    print("캐시 클리어 완료")
  }
    
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
  func loadAllDataIfNeed(forceReload: Bool = false) async {
    guard !isLoading else {
      print("이미 로딩 중")
      return
    }
    logCacheStatus()
    
    if !forceReload && isCacheValid && isDataLoaded {
      print("캐시 데이터 사용하여 서버 호출 스킵")
      return
    }
    
    await loadAllData()
  }
  
  // MARK: 모든 데이터 병렬 함수
  func loadAllData() async {
    isLoading = true
    defer {
      isLoading = false
      lastLoadTime = Date()
      isDataLoaded = true
    }
    
    print("서버 로딩 시작")
    
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
      print("현재 유저의 지원서\(app.count)개 로드")
      
      let uniquePostIds = Set(app.compactMap { $0.postId })
      let uniquePostUUIDs =
      uniquePostIds.compactMap { UUID(uuidString:  $0)}
      
      await withTaskGroup(of: Void.self) { group in
        group.addTask {
          await self.loadApplicationPosts(postIds: Array(uniquePostIds))
        }
        group.addTask {
          await self.loadApplicationSlots(postIds: Array(uniquePostIds))
        }
        group.addTask {
          await self.loadApplicationThumbnails(postUUIDs: uniquePostUUIDs)
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
      print("내가 작성한 공고 \(posts.count)개 로드 성공")
      self.uploadPost = posts
      
      let postIds = posts.map { $0.postId.uuidString }
      let postUUIDs = posts.map { $0.postId }
      
      await withTaskGroup(of: Void.self) { group in
        group.addTask {
          await self.loadUploadSlots(postIds: postIds)
        }
        group.addTask {
          await self.loadUploadThumbnails(postUUIDs: postUUIDs)
        }
      }
    } catch {
      print("내가 올린 공고 로드 실패 \(error)")
    }
  }
}
// MARK: - 개별 데이터 로딩 함수
private extension MyPostsViewModel {
  func loadApplicationPosts(postIds: [String]) async {
    do {
      let allPosts = await withTaskGroup(of: [Post].self, returning: [Post].self) { group in
        for postId in postIds {
          group.addTask {
            do {
              return try await self.fetchApplicationPost(for: postId)
            } catch {
              print("\(postId) 공고 불러오기 실패")
              return []
            }
          }
        }
        // 전체 데이터 결과
        var results: [Post] = []
        for await posts in group {
          results.append(contentsOf: posts)
        }
        return results
      }
      // 실제 변수에 담은 (UI 업데이트)
      await MainActor.run {
        for post in allPosts {
          if !self.applicationPost.contains(where: { $0.postId == post.postId }) {
            self.applicationPost.append(post)
          }
        }
      }
      print("지원한 공고 정보 \(allPosts.count)개 로드 성공")
    }
  }
  
  func loadApplicationSlots(postIds: [String]) async {
    do {
      let allSlots = await withTaskGroup(of: [InterviewSlot].self, returning: [InterviewSlot].self) { group in
        for postId in postIds {
          group.addTask {
            do {
              return try await self.fetchInterviewSlot(for: postId)
            } catch {
              print("\(postId)의 인터뷰 슬롯 로딩 실패")
              return []
            }
          }
        }
        
        var results: [InterviewSlot] = []
        for await slots in group {
          results.append(contentsOf: slots)
        }
        return results
      }
      
      await MainActor.run {
        let newSlotDic = self.mapDicSlot(for: allSlots)
        
        for (key, value) in newSlotDic {
          if self.applicationSlot[key] != nil {
            let existingSlotIds = Set(self.applicationSlot[key]?.map { $0.slotId } ?? [])
            let newSlots = value.filter { !existingSlotIds.contains($0.slotId) }
            self.applicationSlot[key]?.append(contentsOf: newSlots)
          } else {
            self.applicationSlot[key] = value
          }
        }
      }
      print("지원한 공고의 면접 슬롯 \(allSlots.count)개 로드 완료")
    }
  }
  
  func loadApplicationThumbnails(postUUIDs: [UUID]) async {
    guard !postUUIDs.isEmpty else { return }
    
    do {
      let thumbnails = try await firestoreManager.fetchThumbnailsForPost(for: postUUIDs)
      
      await MainActor.run {
        self.applicationThumbnail.merge(thumbnails) { _, new in new }
      }
      print("지원한 공고의 썸네일 \(thumbnails.count)개 로드 완료")
    } catch {
      print("지원한 공고 썸네일 로딩 실패 \(error)")
    }
  }
  
  func loadUploadSlots(postIds: [String]) async {
    do {
      let allSlots = await withTaskGroup(of: [InterviewSlot].self, returning: [InterviewSlot].self) { group in
        for postId in postIds {
          group.addTask {
            do {
              return try await self.fetchInterviewSlot(for: postId)
            } catch {
              print("\(postId)의 모집한 인터뷰 슬롯 로드 실패")
              return []
            }
          }
        }
        
        var results: [InterviewSlot] = []
        for await slots in group {
          results.append(contentsOf: slots)
        }
        return results
      }
      
      await MainActor.run {
        let newSlotDic = self.mapDicSlot(for: allSlots)
        
        for (key, value) in newSlotDic {
          if self.uploadPostSlot[key] != nil {
            let existingSlotIds = Set(self.uploadPostSlot[key]?.map { $0.slotId } ?? [] )
            let newSlots = value.filter { !existingSlotIds.contains($0.slotId) }
            self.uploadPostSlot[key]?.append(contentsOf: newSlots)
          } else {
            self.uploadPostSlot[key] = value
          }
        }
      }
      
      print("내가 올린 공고 면접 슬롯 \(allSlots.count)개 로드 완료")
    }
  }
  
  func loadUploadThumbnails(postUUIDs: [UUID]) async {
    guard !postUUIDs.isEmpty else { return }
    
    do {
      let thumbnails = try await firestoreManager.fetchThumbnailsForPost(for: postUUIDs)
      
      await MainActor.run {
        self.uploadThumbnail.merge(thumbnails) { _, new in new }
      }
      print("내가 올린 공고 썸네일 \(thumbnails.count)개 로드 완료")
    } catch {
      print("내가 올린 공고 썸네일 로딩 실패 \(error)")
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
  
  func fetchApplicationPost(for postId: String) async throws -> [Post] {
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
