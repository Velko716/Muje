//
//  ApplicationStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation

enum ApplicationStatus: String, Codable {
    case submitted = "지원서 제출됨"
    case interviewWaiting = "면접 대기 중"
    case reviewWaiting = "심사 대기 중"
    case reviewCompleted = "심사 완료됨"
}
