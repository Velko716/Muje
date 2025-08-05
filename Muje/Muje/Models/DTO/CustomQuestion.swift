//
//  CustomQuestions.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct CustomQuestion: Codable {
    let questionId: UUID
    let postId: String
    let questionText: String
    let questionOrder: Int
    @ServerTimestamp var createdAt: Timestamp?
    
    init(
        questionId: UUID,
        postId: String,
        questionText: String,
        questionOrder: Int,
        createdAt: Timestamp? = nil
    ) {
        self.questionId = questionId
        self.postId = postId
        self.questionText = questionText
        self.questionOrder = questionOrder
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case postId = "post_id"
        case questionText = "question_text"
        case questionOrder = "question_order"
        case createdAt = "created_at"
    }
}

extension CustomQuestion {
    var entityName: CollectionType { .customQuestions }

    var documentID: String { questionId.uuidString }
        
    var asDictionary: [String: Any]? {
        [
            "question_id": questionId.uuidString,
            "post_id": postId,
            "question_text": questionText,
            "question_order": questionOrder,
            //"created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
