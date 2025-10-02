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
      selectedSlots.removeAll { $0.startTime.stripTime() == day }
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
    return lhs.startTime < rhs.startTime
  }
  
  var interviewSlotLists: [InterviewSlot] = [] //인터뷰 슬롯 DTO에 필요
  
  //슬롯들 시간 순으로 정렬하는 함수
  func slotUpdate() {
    self.selectedSlots.sort(by: ascending)
  }
  
  func checkSlot(date: Date, startDate: Date, endDate: Date) -> Bool {
    return !(startDate <= date && date < endDate)
  }
  
  func createPicker(for date: Date, startTime: Date? = nil) {
    var timeSlots: [Date] {
      var slots: [Date] = []
      var currentTime = date.setTo9AM()
      
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
    
    let start = startTime ?? date.setTo9AM()
    let end = start.addingTimeInterval(TimeInterval(60 * timeInterval))
    
    selectedSlots.append(
      .init(
        startTime: start,
        endTime: end,
        isStartShown: false,
        isEndShown: false,
        timeLists: timeSlots
      )
    )
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
    selectedSlots.append(.init(startTime: calendarDay.date.setTo9AM(), endTime: calendarDay.date.setTo9AM().addingTimeInterval(TimeInterval(60 * timeInterval)), isStartShown: false, isEndShown: false, timeLists: timeSlots))
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

extension InterviewSlotViewModel {
    var groupedSlots: [Date: [TimeModel]] {
        Dictionary(grouping: selectedSlots) { $0.startTime.stripTime() }
    }
}

extension InterviewSlotViewModel {
  /// timeInterval 변경 시 모든 기존 슬롯들의 시간을 새로운 간격에 맞춰 연쇄적으로 업데이트
  func updateSlotsForNewTimeInterval() {
    // 날짜별로 그룹화된 슬롯들을 처리
    let groupedSlots = Dictionary(grouping: selectedSlots) { $0.startTime.stripTime() }
    
    for (date, slots) in groupedSlots {
      // 해당 날짜의 슬롯들을 시작 시간 순으로 정렬
      let sortedSlots = slots.sorted { $0.startTime < $1.startTime }
      
      for (index, slot) in sortedSlots.enumerated() {
        if let slotIndex = selectedSlots.firstIndex(where: { $0.id == slot.id }) {
          if index == 0 {
            // 첫 번째 슬롯: 시작시간은 그대로, 종료시간만 새로운 간격으로
            let newEndTime = slot.startTime.addingTimeInterval(TimeInterval(60 * timeInterval))
            selectedSlots[slotIndex].endTime = newEndTime
          } else {
            // 두 번째 슬롯부터: 이전 슬롯의 종료시간을 시작시간으로, 새로운 간격으로 종료시간 설정
            let previousSlot = sortedSlots[index - 1]
            let previousSlotIndex = selectedSlots.firstIndex(where: { $0.id == previousSlot.id })!
            let newStartTime = selectedSlots[previousSlotIndex].endTime
            let newEndTime = newStartTime.addingTimeInterval(TimeInterval(60 * timeInterval))
            
            selectedSlots[slotIndex].startTime = newStartTime
            selectedSlots[slotIndex].endTime = newEndTime
          }
          
          // 해당 날짜의 새로운 시간 선택 리스트 생성
          selectedSlots[slotIndex].timeLists = generateTimeSlots(for: date)
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
