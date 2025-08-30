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
    var customQuestions: [DraftCustomQuestion] = []
  
    var canSubmit: Bool {
      let hasBasicInfo = basicInfoChecked.values.contains(true)
      let validQuestionCount = customQuestions.filter {
        !$0.questionText.trimmingCharacters(in: .whitespaces).isEmpty
      }.count
      return hasBasicInfo && validQuestionCount >= 1
    }
  
  init() {
    RecruitmentField.allCases.forEach { field in
      basicInfoChecked[field] = field == .name
    }
  }
    //TODO: 뷰모델에서 개수 세긴 하는데 뷰에서 연결을 안햇네욤;;ㅎㅎ
    
    var postButtonColor: Color {
        canSubmit ? Color.black : Color.gray
    }
  
  // MARK: - CustomQuestion 관련 로직
  func addCustomQuestion() {
    let newQue = DraftCustomQuestion(
      questionText: "",
      questionOrder: customQuestions.count + 1
    )
    customQuestions.append(newQue)
  }
  
  func updateCustomQuestion(id: UUID, text: String) {
    if let index = customQuestions.firstIndex(where: { $0.id == id }) {
      customQuestions[index].questionText = text
    }
  }
  
  func removeCustomQuestion(id: UUID) {
    customQuestions.removeAll { $0.id == id }
    
    for index in customQuestions.indices {
      customQuestions[index].questionOrder = index + 1
    }
  }
  
  // MARK: - Firebase Create
  func createCustomQuestion(for postId: String) -> [CustomQuestion] {
    return customQuestions.enumerated().compactMap { index, question in
      guard question.isValid else { return nil }
      
      return CustomQuestion(questionId: UUID(), postId: postId, questionText: question.questionText, questionOrder: index + 1)
    }
  }
}

struct DraftCustomQuestion: Identifiable {
  let id = UUID()
  var questionText: String = ""
  var questionOrder: Int
  
  var isValid: Bool {
    !questionText.trimmingCharacters(in: .whitespaces).isEmpty
  }
}
