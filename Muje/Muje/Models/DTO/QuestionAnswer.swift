//
//  QuestionAnswer.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct QuestionAnswer: Codable {
    let answerId: UUID
    let applicationId: String
    let questionId: String
    let questionText: String
    let answerText: String
    @ServerTimestamp var createdAt: Timestamp?

    init(
        answerId: UUID,
        applicationId: String,
        questionId: String,
        questionText: String,
        answerText: String,
        createdAt: Timestamp? = nil
    ) {
        self.answerId = answerId
        self.applicationId = applicationId
        self.questionId = questionId
        self.questionText = questionText
        self.answerText = answerText
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case applicationId = "application_id"
        case questionId = "question_id"
        case questionText = "question_text"
        case answerText = "answer_text"
        case createdAt = "created_at"
    }
}

extension QuestionAnswer: EntityRepresentable {
    var entityName: CollectionType { .questionAnswers }

    var documentID: String { answerId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "answer_id": answerId.uuidString,
            "application_id": applicationId,
            "question_id": questionId,
            "question_text": questionText,
            "answer_text": answerText,
            //"created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
