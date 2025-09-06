//
//  SelectViewModel.swift
//  Muje
//
//  Created by Air on 9/3/25.
//

import SwiftUI

@Observable
final class SelectViewModel {
    var str = "날짜를 선택하세요"
    var currentDate: Date?
    var currentIndex: Int?
    var isSetting: Bool = false //모달 관리
    var isSelected: Bool = false //선택 관리
    var lists: [InterviewSlot] = []
    
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
}
