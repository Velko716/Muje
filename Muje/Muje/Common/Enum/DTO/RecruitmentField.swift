//
//  RecruitmentField.swift
//  Muje
//
//  Created by 김서현 on 8/22/25.
//

import Foundation

enum RecruitmentField: String, CaseIterable, Identifiable {
    case name = "지원자 이름"
    case gender = "성별"
    case age = "나이"
    case major = "학과/전공"
    case studentId = "학번"
    case contact = "연락처"
    
    var id: String { rawValue } //ForEach에서 사용할 용도
}
