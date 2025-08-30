//
//  TextModel.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import Foundation

struct TextModel: Identifiable, Equatable {
    let id: TextViewType
    var title: String
    var content: String

    init(type: TextViewType) {
        self.id = type
        self.title = type.title
        self.content = type.content
    }
}
