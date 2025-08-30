//
//  InterviewSlotViewModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI


@Observable
class InterviewSlotViewModel {
    var selectedSlots: [TimeModel] = []
    var maxCount: Int = 1
    var timeInterval: Int = 30
    
    //배열 오름차순으로 정렬하는 조건
    let ascending: (TimeModel, TimeModel) -> Bool = { (lhs, rhs) in
        return lhs.startTime < rhs.startTime
    }
    
    var interviewSlotLists: [InterviewSlotModel] = [] //인터뷰 슬롯 DTO에 필요
    
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
        selectedSlots.append(.init(startTime: calendarDay.date.setTo9AM(), endTime: calendarDay.date.setTo9AM().addingTimeInterval(TimeInterval(60 * timeInterval)), isStartShown: false, isEndShown: false, timeLists: timeSlots))
    }
    
    //선택된 캘린더 슬롯에서 당일 인터뷰 슬롯 생성하는 함수
    func generateSlot(from startTime: Date, to endTime: Date) {
        let title = "post_ID"
        
        let calendar = Calendar.current
        var currentDate = startTime
        
        while currentDate <= endTime {
            let model = InterviewSlotModel(postId: title, interviewDate: currentDate, interviewTime: currentDate, maxCapacity: maxCount, currentReservations: 0, createdAt: .now)
            interviewSlotLists.append(model)
            guard let nextDate = calendar.date(byAdding: .minute, value: timeInterval, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
    }
    
    //선택된 캘린더 슬롯에서 모든 시간 당 인터뷰 슬롯 생성하는 함수 -> 인터뷰 슬롯 리스트에 저장됨
    func updateAllSlot() {
        for list in selectedSlots {
            generateSlot(from: list.startTime, to: list.endTime)
        }
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
        if interviewSlotLists.isEmpty {
            return "시작일 ~ 마감일 설정"
        } else {
            return "\(interviewSlotLists.first?.interviewTime.shortDateString ?? "시작오류") ~ \(interviewSlotLists.last?.interviewTime.shortDayString ?? "끝 오류")"
        }
    }
    
    func slotDebug() {
        print("maxCapacity: \(maxCount)")
        print("timeInterval: \(timeInterval)")
        
        for slot in interviewSlotLists {
            if interviewSlotLists.first?.id == slot.id {
                print("postID: \(slot.postId)")
                print("currentReservation: \(slot.currentReservations)")
                print("---------------------------------")
            }
            
            print("\(slot.interviewDate.shortDateString)")
            print("\(slot.interviewTime.hourMinute24)")
            
        }
    }
}
