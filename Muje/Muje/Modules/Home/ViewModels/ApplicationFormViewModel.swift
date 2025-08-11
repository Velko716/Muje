//
//  ApplicationFormViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import Foundation
import FirebaseFirestore

@Observable
final class ApplicationFormViewModel {
  
  private let firestoreManager = FirestoreManager.shared
  
  var customQuestion: [CustomQuestion] = []
  
  func loadCustomQuestion(for postId: String) async {
    do {
      let question = try await fetchCustomQuestion(for: postId)
      self.customQuestion = question
      
    } catch {
      print("커스텀 질문 목록 로드 실패")
    }
  }
}

private extension ApplicationFormViewModel {
  func fetchCustomQuestion(for postId: String) async throws -> [CustomQuestion] {
    return try await firestoreManager.fetchWithCondition(
      from: .customQuestions,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.questionOrder < $1.questionOrder }
    )
  }
}
