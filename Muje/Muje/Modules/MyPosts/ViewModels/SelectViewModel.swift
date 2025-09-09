//
//  SelectViewModel.swift
//  Muje
//
//  Created by Air on 9/3/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
final class SelectViewModel {
  
    private let firestoreManager = FirestoreManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared
  
  // MARK: 현재 유저 ID
//  var currentUserId: String? {
//    guard let currentUser = firebaseAuthManager.currentUser else { return nil }
//
//    return currentUser.userId
//  }
  
    private let currentUserId: String? = "0062C371-34F5-470B-BFE1-F671E23C5C97"
  
    var str = "날짜를 선택하세요"
    var currentDate: Date?
    var currentIndex: Int?
    var isSetting: Bool = false //모달 관리
    var isSelected: Bool = false //선택 관리
    var lists: [InterviewSlot] = []
    var isLoading: Bool = false
  
  // MARK: 데이터 전달 구조 개선
  var currentPostId: UUID?
  var currentApplicationId: UUID?
  var currentApplication: Application?
  
  func prepareForInterview(
    postId: UUID,
    application: Application,
//    slots: [InterviewSlot]
  ) {
    self.currentPostId = postId
    self.currentApplicationId = application.applicationId
    self.currentApplication = application
//    self.lists = slots
  }
    
    func checkMax(slot: InterviewSlot) -> Bool {
        return slot.currentReservations >= slot.maxCapacity
    }
    
    func buttonString() {
        if currentDate != nil {
            if currentIndex != nil {
                str = "면접일정 예약하기"
            } else {
                str = "시간을 선택하세요"
            }
        }
    }
  
  func updated() async {
    guard let postId = currentPostId,
            let applicationId = currentApplicationId,
            let application = currentApplication else {
      return
    }
    
    isLoading = true
    defer { isLoading = false }
    
    do {
      guard let updatedSlot = updatedSlot() else { return }
      
      let updatedApp = Application(
        applicationId: applicationId,
        applicantUserId: currentUserId ?? "", // FIXME: 목데이터
        postId: postId.uuidString,
        status: application.status,
        interviewSlotId: updatedSlot.slotId.uuidString, // 업데이트
        applicantName: application.applicantName,
        postTitle: application.postTitle,
        postOrganization: application.postOrganization,
        postAuthorUserId: application.postAuthorUserId
      )
      
      async let slot = firestoreManager.update(updatedSlot)
      async let app = firestoreManager.update(updatedApp)
      
      _ = try await slot
      _ = try await app
      
      print("면접 예약 완료")
    } catch {
      print("인터뷰 슬롯 업데이트 실패")
    }
  }
  
  private func updatedSlot() -> InterviewSlot? {
    guard let idx = currentIndex else { return nil }
    let slot = lists[idx]
    
    let currentReservations: Int = slot.currentReservations
    
    let updatedSlot = InterviewSlot(
      slotId: slot.slotId,
      postId: slot.postId,
      interviewDate: slot.interviewDate,
      interviewTime: slot.interviewTime,
      maxCapacity: slot.maxCapacity,
      currentReservations: currentReservations + 1,
      createdAt: Timestamp(date: Date())
    )
    return updatedSlot
  }
}
