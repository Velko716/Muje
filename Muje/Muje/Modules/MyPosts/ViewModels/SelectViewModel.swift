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
    var lists: [InterviewSlotModel] = [
        .init(postId: "qq", interviewDate: Date(), interviewTime: Date(), maxCapacity: 3, currentReservations: 2, createdAt: .now),
        .init(postId: "aa", interviewDate: Date().addingTimeInterval(3600 * 24), interviewTime: Date().addingTimeInterval(3600 * 24), maxCapacity: 2, currentReservations: 1, createdAt: .now),
        .init(postId: "zz", interviewDate: Date().addingTimeInterval(3600 * 24 * 2), interviewTime: Date().addingTimeInterval(3600 * 24 * 2), maxCapacity: 1 , currentReservations: 0, createdAt: .now),
        .init(postId: "rr", interviewDate: Date().addingTimeInterval(3600 * 24 * 2 + 3600 * 3), interviewTime: Date().addingTimeInterval(3600 * 24 * 2 + 3066 * 3), maxCapacity: 1 , currentReservations: 0, createdAt: .now),
        .init(postId: "tt", interviewDate: Date().addingTimeInterval(3600 * 24 * 2 + 3600 * 4), interviewTime: Date().addingTimeInterval(3600 * 24 * 2 + 3600 * 4), maxCapacity: 1 , currentReservations: 0, createdAt: .now),
        .init(postId: "ww", interviewDate: Date().addingTimeInterval(3600 * 24 * 3), interviewTime: Date().addingTimeInterval(3600 * 24 * 3), maxCapacity: 1 , currentReservations: 0, createdAt: .now),
        .init(postId: "ss", interviewDate: Date().addingTimeInterval(3600 * 24 * 4), interviewTime: Date().addingTimeInterval(3600 * 24 * 4), maxCapacity: 1 , currentReservations: 1, createdAt: .now),
        .init(postId: "ee", interviewDate: Date().addingTimeInterval(3600 * 24 * 6), interviewTime: Date().addingTimeInterval(3600 * 24 * 6), maxCapacity: 3, currentReservations: 3, createdAt: .now)
    ] //application DTO에서 postID를 받아와서 동일한 postID를 갖는 InterviewSlot DTO들 받아오기
    
    func checkMax(slot: InterviewSlotModel) -> Bool {
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
