//
//  InterviewSlotModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct InterviewSlotModel: Identifiable {
    let id: UUID = .init() //슬롯 아이디
    var postId: String //포스트 아이디(공고ID받아옴)
    var interviewDate: Date //면접 날짜
    var interviewTime: Date //면접 시간
    var maxCapacity: Int //면접 한 타임 당 최대 인원
    var currentReservations: Int //현재 예약된 인원
    var createdAt: Date //생성 시간
}
