//
//  RecruitmentPostViewModel.swift
//  Muje
//
//  Created by 김서현 on 8/22/25.
//

import Foundation
import SwiftUI

@Observable
class RecruitmentPostViewModel {
    var basicInfoChecked: [RecruitmentField: Bool] = [:]
    var customQuestions: [UUID: String] = [:]
    var canSubmit: Bool {
        let basicInfoCount = basicInfoChecked.values.filter {$0}.count
        let customQuestionCount = customQuestions.values.filter { !$0.isEmpty }.count
        return basicInfoCount >= 1 && customQuestionCount >= 1
    }
    
    //TODO: 뷰모델에서 개수 세긴 하는데 뷰에서 연결을 안햇네욤;;ㅎㅎ
    
    var postButtonColor: Color {
        canSubmit ? Color.black : Color.gray
    }
    
    init() {
        RecruitmentField.allCases.forEach { field in
            basicInfoChecked[field] = field == .name
        }
    }
}
