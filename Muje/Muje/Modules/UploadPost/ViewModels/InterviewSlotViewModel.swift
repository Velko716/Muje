//
//  InterviewSlotViewModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI
import FirebaseFirestore

extension Date {
  /// 시·분·초 제거 → 자정으로 설정
  func stripTime() -> Date {
    let calendar = Calendar.current
    return calendar.startOfDay(for: self)
  }
}

@Observable
final class InterviewSlotViewModel {
    
  private let firestoreManager = FirestoreManager.shared
  var isLoading: Bool = false
    
  var selectedSlots: [TimeModel] = []
  var maxCount: Int = 1
  var timeInterval: Int = 30
  var selectedSlot: [Date: [InterviewSlot]] = [:]
  var selectedDays: Set<Date> = []
  var lastSelectedDate: Date?
  
  func toggleDate(calendarDay: CalendarDay) {
    let day = calendarDay.date.stripTime()
    if selectedDays.contains(day) {
      selectedDays.remove(day)
        selectedSlots.removeAll { $0.startTime.dateValue().stripTime() == day }
      if lastSelectedDate == day {
        lastSelectedDate = selectedDays.max()
      }
    } else {
      selectedDays.insert(day)
      createPicker(calendarDay: calendarDay)
    
      lastSelectedDate = day
    }
  }
  
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
        selectedSlots.append(.init(timeId: .init(), postId: "", startTime: Timestamp(date: calendarDay.date.setTo9AM()), endTime: Timestamp(date: calendarDay.date.setTo9AM().addingTimeInterval(TimeInterval(60 * timeInterval))), isStartShown: false, isEndShown: false))
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
        if let index = selectedSlots.firstIndex(where: { $0.timeId == id }) {
            selectedSlots.remove(at: index)
        }
    }
    
    //선택된 캘린더 슬롯에서 모든 시간 당 인터뷰 슬롯 생성하는 함수 -> 인터뷰 슬롯 리스트에 저장됨
  func updateAllSlot(postId: String) -> [InterviewSlot] {
        for list in selectedSlots {
            generateSlot(from: list.startTime.dateValue(), to: list.endTime.dateValue(), postId: postId)
        }
    return interviewSlotLists
    }
    
    //인터뷰 시작 시간이 변경될 때마다 인터뷰 종료 피커들을 변경하는 함수
    func updateSlotTime(slot: Binding<TimeModel>) -> [Timestamp] {
        var timeSlots: [Timestamp] {
            var slots: [Timestamp] = []
            var currentTime = slot.startTime.wrappedValue.dateValue()
            
            while currentTime <= slot.startTime.wrappedValue.dateValue().endOfDay() {
                slots.append(Timestamp(date: currentTime))
                if let nextTime = Calendar.current.date(byAdding: .minute, value: timeInterval, to: currentTime) {
                    currentTime = nextTime
                } else {
                    break
                }
            }
            return slots
        }
        return timeSlots
    }
    
    //인터뷰 슬롯의 시작 날짜와 종료 날짜를 출력하는 함수
    func datePrint() -> String {
        if selectedSlots.isEmpty {
            return "시작일 ~ 마감일 설정"
        } else {
            return "\(selectedSlots.first?.startTime.dateValue().dateString ?? "시작오류") ~ \(selectedSlots.last?.startTime.dateValue().dateString ?? "끝 오류"))"
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

extension InterviewSlotViewModel {
    var groupedSlots: [Date: [TimeModel]] {
        Dictionary(grouping: selectedSlots) { $0.startTime.dateValue().stripTime() }
    }
}

extension InterviewSlotViewModel {
    /// timeInterval 변경 시 모든 기존 슬롯들의 시간을 새로운 간격에 맞춰 연쇄적으로 업데이트
    func updateSlotsForNewTimeInterval() {
        // 날짜별로 그룹화된 슬롯들을 처리
        let groupedSlots = Dictionary(grouping: selectedSlots) { $0.startTime.dateValue().stripTime() }
        
        for (date, slots) in groupedSlots {
            // 해당 날짜의 슬롯들을 시작 시간 순으로 정렬
            let sortedSlots = slots.sorted { $0.startTime.dateValue() < $1.startTime.dateValue() }
            
            for (index, slot) in sortedSlots.enumerated() {
                if let slotIndex = selectedSlots.firstIndex(where: { $0.timeId == slot.timeId }) {
                    if index == 0 {
                        // 첫 번째 슬롯: 시작시간은 그대로, 종료시간만 새로운 간격으로
                        let newEndTime = slot.startTime.dateValue().addingTimeInterval(TimeInterval(60 * timeInterval))
                        selectedSlots[slotIndex].endTime = Timestamp(date: newEndTime)
                    } else {
                        // 두 번째 슬롯부터: 이전 슬롯의 종료시간을 시작시간으로, 새로운 간격으로 종료시간 설정
                        let previousSlot = sortedSlots[index - 1]
                        let previousSlotIndex = selectedSlots.firstIndex(where: { $0.timeId == previousSlot.timeId })!
                        let newStartTime = selectedSlots[previousSlotIndex].endTime
                        let newEndTime = newStartTime.dateValue().addingTimeInterval(TimeInterval(60 * timeInterval))
                        
                        selectedSlots[slotIndex].startTime = newStartTime
                        selectedSlots[slotIndex].endTime = Timestamp(date: newEndTime)
                    }
                    
                    // 해당 날짜의 새로운 시간 선택 리스트 생성
//                    selectedSlots[slotIndex].timeLists = generateTimeSlots(for: date)
                }
            }
        }
    }
    
    /// 특정 날짜의 시간 슬롯 생성 (기존 코드를 재사용)
    private func generateTimeSlots(for date: Date) -> [Date] {
        var slots: [Date] = []
        var currentTime = date.stripTime().setTo9AM()
        
        while currentTime <= date.endOfDay() {
            slots.append(currentTime)
            if let nextTime = Calendar.current.date(byAdding: .minute, value: timeInterval, to: currentTime) {
                currentTime = nextTime
            } else {
                break
            }
        }
        return slots
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
  // MARK: updated,create,delete 병렬 처리
  func saveAll(
    postId: String
  ) async throws {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try await withThrowingTaskGroup(of: Void.self) { group in
        group.addTask {
          await self.updateTimeModel(for: postId)
        }
        group.addTask {
          await self.updateSlot(
            postId: postId
          )
        }
        try await group.waitForAll()
      }
    } catch {
      print("면접 일정 업데이트 실패 \(error)")
    }
  }
  // MARK: update, create 분기 저장 함수
    private func updateTimeModel(for postId: String) async {
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
  // MARK: InterviewSlot 생성
  private func updateSlot(
    postId: String
  ) async {
    do {
      let existingSlots = try await fetchSlot(postId: postId)
      
      var reservationMal: [String: Int] = [:]
      for existingSlot in existingSlots {
        let dateStr = existingSlot.interviewDate.dateValue().dateString
        let timeStr = existingSlot.interviewTime
        let key = "\(dateStr)_\(timeStr)"
        reservationMal[key] = existingSlot.currentReservations
      }
      
        for existingSlot in existingSlots {
          try await firestoreManager.delete(
            collectionType: .interviewSlots,
            documentID: existingSlot.slotId.uuidString
          )
        }
        
        let newSlots = generateNewSlots(
          postId: postId,
          reservationMap: reservationMal
        )
        
        for newSlot in newSlots {
          _ = try await firestoreManager.create(newSlot)
        }
      } catch {
        print("interviewSlot 동기화 실패 \(error)")
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
    private func fetchSlot(postId: String) async throws -> [InterviewSlot] {
    return try await firestoreManager.fetchWithCondition(
      from: .interviewSlots,
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
  
  private func generateNewSlots(
    postId: String,
    reservationMap: [String: Int]
  ) -> [InterviewSlot] {
    interviewSlotLists.removeAll()
    
    for timeModel in selectedSlots {
      let calender = Calendar.current
      var currentDate = timeModel.startTime.dateValue()
      
      while currentDate <= timeModel.endTime.dateValue() {
        
        let dateStr = currentDate.dateString
        let timeStr = currentDate.hourMinute24
        let key = "\(dateStr)_\(timeStr)"
        
        let savedReservations = reservationMap[key] ?? 0
        
        let model = InterviewSlot(
          slotId: UUID(),
          postId: postId,
          interviewDate: Timestamp(date: currentDate),
          interviewTime: currentDate.hourMinute24,
          maxCapacity: maxCount,
          currentReservations: savedReservations,
          createdAt: Timestamp(date: Date())
        )
        interviewSlotLists.append(model)
        guard let nexDate = calender.date(byAdding: .minute, value: timeInterval, to: currentDate) else {
          break
        }
        currentDate = nexDate
      }
    }
    return interviewSlotLists
  }
  
  private func updatedWithUUID(
    postId: String,
    existingSlots: [InterviewSlot]
  ) -> [InterviewSlot] {
    interviewSlotLists.removeAll()
    
    for timeModel in selectedSlots {
      generateWithUUID(
        from: timeModel.startTime.dateValue(),
        to: timeModel.endTime.dateValue(),
        postId: postId,
        existingSlots: existingSlots
      )
    }
    return interviewSlotLists
  }
  
  private func generateWithUUID(
    from startTime: Date,
    to endTime: Date,
    postId: String,
    existingSlots: [InterviewSlot]
  ) {
    let calender = Calendar.current
    var currentDate = startTime
    
    while currentDate <= endTime {
      let timeString = currentDate.hourMinute24
      
      let existingSlot = existingSlots.first { slot in
        let slotData = slot.interviewDate.dateValue()
        return Calendar.current.isDate(slotData, inSameDayAs: currentDate) && slot.interviewTime == timeString
      }
      
      let slotId = existingSlot?.slotId ?? UUID()
      
      let model = InterviewSlot(
        slotId: slotId,
        postId: postId,
        interviewDate: Timestamp(date: currentDate),
        interviewTime: timeString,
        maxCapacity: maxCount,
        currentReservations: existingSlot?.currentReservations ?? 0,
        createdAt: existingSlot?.createdAt ?? Timestamp(date: Date())
      )
      
      interviewSlotLists.append(model)
      guard let nexDate = calender.date(byAdding: .minute, value: timeInterval, to: currentDate) else {
        break
      }
      currentDate = nexDate
    }
  }
}
