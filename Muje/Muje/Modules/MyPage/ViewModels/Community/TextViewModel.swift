//
//  TextViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/27/25.
//

import Foundation

@Observable
final class TextViewModel {
    var title: String 
    var text: String

    // enum으로 받기
    convenience init(type: TextViewType) {
        let model = TextModel(type: type)
        self.init(model: model)
    }

    // 모델로 받기
    init(model: TextModel) {
        self.title = model.title
        self.text = model.content
    }

}
