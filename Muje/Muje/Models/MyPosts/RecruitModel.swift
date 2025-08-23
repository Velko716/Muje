//
//  RecruitModel.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct RecruitModel {
    var title: String //공고 제목
    var interviewDate: Date //면접이 존재하는 날짜
    var maxCapacity: Int //공고 한 타임 당 최대 인원
    var timeLists: [InterviewTimeModel] //공고 인터뷰 슬롯리스트
}
