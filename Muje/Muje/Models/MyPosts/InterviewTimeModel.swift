//
//  InterviewTimeModel.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import Foundation

struct InterviewTimeModel: Equatable {
    let userID: String //유저아이디로 서버에서 검색하기 위한 값
    var interviewTime: Date //인터뷰 시간
    var title: String //인터뷰 공고 제목
}
