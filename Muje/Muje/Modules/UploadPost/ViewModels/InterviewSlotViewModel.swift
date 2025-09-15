//
//  InterviewSlotViewModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI
import FirebaseFirestore


@Observable
class InterviewSlotViewModel {
  
    private let firestoreManager = FirestoreManager.shared
    var isLoading: Bool = false
  
    var selectedSlots: [TimeModel] = []
    var maxCount: Int = 1
    var timeInterval: Int = 30
    
    //배열 오름차순으로 정렬하는 조건
    let ascending: (TimeModel, TimeModel) -> Bool = { (lhs, rhs) in
      return lhs.startTime.dateValue() < rhs.startTime.dateValue()
    }
    
    var interviewSlotLists: [InterviewSlot] = [] //인터뷰 슬롯 DTO에 필요
    
    //슬롯들 시간 순으로 정렬하는 함수
    func slotUpdate() {
        self.selectedSlots.sort(by: ascending)
    }
    
    func checkSlot(date: Date, startDate: Date, endDate: Date) -> Bool {
        return !(startDate <= date && date < endDate)
    }
    
    //캘린더 슬롯을 누르면 인터뷰 시간을 설정할 수 있는 피커 리스트 생성
    func createPicker(calendarDay: CalendarDay) {
        var timeSlots: [Date] {
            var slots: [Date] = []
            var currentTime = calendarDay.date.setTo9AM()
            
            while currentTime <= calendarDay.date.endOfDay() {
                slots.append(currentTime)
                if let nextTime = Calendar.current.date(byAdding: .minute, value: timeInterval, to: currentTime) {
                    currentTime = nextTime
                } else {
                    break
                }
            }
            return slots
        }
        selectedSlots.append(.init(startTime: calendarDay.date.setTo9AM(), endTime: calendarDay.date.setTo9AM().addingTimeInterval(TimeInterval(60 * timeInterval)), isStartShown: false, isEndShown: false))
    }
    
    //선택된 캘린더 슬롯에서 당일 인터뷰 슬롯 생성하는 함수
    func generateSlot(from startTime: Date, to endTime: Date, postId: String) {
        
        let calendar = Calendar.current
        var currentDate = startTime
        
        while currentDate <= endTime {
          let model = InterviewSlot(
            slotId: UUID(),
            postId: postId,
            interviewDate: Timestamp(date: currentDate),
            interviewTime: currentDate.hourMinute24,
            createdAt: Timestamp(date: Date())
          )
            interviewSlotLists.append(model)
            guard let nextDate = calendar.date(byAdding: .minute, value: timeInterval, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
    }
    
    func removeItem(withId id: UUID) {
        if let index = selectedSlots.firstIndex(where: { $0.id == id }) {
            selectedSlots.remove(at: index)
        }
    }
    
    //선택된 캘린더 슬롯에서 모든 시간 당 인터뷰 슬롯 생성하는 함수 -> 인터뷰 슬롯 리스트에 저장됨
  func updateAllSlot(postId: String) -> [InterviewSlot] {
        for list in selectedSlots {
          generateSlot(from: list.startTime, to: list.endTime, postId: postId)
        }
    return interviewSlotLists
    }
    
    //인터뷰 시작 시간이 변경될 때마다 인터뷰 종료 피커들을 변경하는 함수
    func updateSlotTime(slot: Binding<TimeModel>) {
        slot.endTime.wrappedValue = slot.startTime.wrappedValue.addingTimeInterval(TimeInterval(60 * timeInterval))
        var timeSlots: [Date] {
            var slots: [Date] = []
            var currentTime = slot.startTime.wrappedValue
            
            while currentTime <= slot.startTime.wrappedValue.endOfDay() {
                slots.append(currentTime)
                if let nextTime = Calendar.current.date(byAdding: .minute, value: timeInterval, to: currentTime) {
                    currentTime = nextTime
                } else {
                    break
                }
            }
            return slots
        }
        slot.timeLists.wrappedValue = timeSlots
    }
    
    //인터뷰 슬롯의 시작 날짜와 종료 날짜를 출력하는 함수
    func datePrint() -> String {
        if selectedSlots.isEmpty {
            return "시작일 ~ 마감일 설정"
        } else {
          return "\(selectedSlots.first?.startTime.dateString ?? "시작오류") ~ \(selectedSlots.last?.startTime.dateString ?? "끝 오류")"
        }
    }
    
    func slotDebug() {
        print("maxCapacity: \(maxCount)")
        print("timeInterval: \(timeInterval)")
        
        for slot in interviewSlotLists {
            if interviewSlotLists.first?.slotId == slot.slotId {
                print("postID: \(slot.postId)")
                print("currentReservation: \(slot.currentReservations)")
                print("---------------------------------")
            }
            
            print("\(slot.interviewDate)")
            print("\(slot.interviewTime)")
            
        }
    }
}

// MARK: KADAN
extension InterviewSlotViewModel {
  // MARK: TimeModel 로드
  func loadTimeModel(for postId: String) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let t = try await fetchTimeModel(postId: postId)
      self.selectedSlots = t
      
    } catch {
      print("TimeModel 로드 실패")
    }
  }
  // MARK: update, create 분기 저장 함수
  func saveTimeModel(for postId: String) async {
    do {
      let exist = try await fetchTimeModel(postId: postId)
      
      // update or create
      for slot in selectedSlots {
        if exist.contains(where: { $0.timeId == slot.timeId}) {
          _ = try await firestoreManager.update(slot)
        } else {
          await createNewTimeModel(slot, postId: postId)
        }
      }
      // 삭제
      for slot in exist {
        if !selectedSlots.contains(
          where: {
            $0.timeId == slot.timeId
          }) {
          try await firestoreManager.delete(
            collectionType: .timeModel,
            documentID: slot.timeId.uuidString
          )
        }
      }
    } catch {
      print("saveTimeModel 동기화 실패 \(error)")
    }
  }
  // MARK: postId 조건 쿼리문
  private func fetchTimeModel(
    postId: String
  ) async throws -> [TimeModel] {
    return try await firestoreManager.fetchWithCondition(
      from: .timeModel,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: {
        $0.createdAt?.dateValue() ?? Date() < $1.createdAt?.dateValue() ?? Date()
      }
    )
  }
  // MARK: 단일 TimeModel create 생성 함수
  private func createNewTimeModel(
    _ slot: TimeModel,
    postId: String
  ) async {
    let newSlot = TimeModel(
      timeId: slot.timeId,
      postId: postId,
      startTime: slot.startTime,
      endTime: slot.endTime,
      isStartShown: slot.isStartShown,
      isEndShown: slot.isEndShown,
      createdAt: Timestamp()
    )
    _ = try? await firestoreManager.create(newSlot)
  }
}
