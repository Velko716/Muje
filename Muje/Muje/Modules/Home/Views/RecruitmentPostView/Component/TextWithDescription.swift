//
//  TextWithDescription.swift
//  Muje
//
//  Created by 김서현 on 8/21/25.
//

import SwiftUI

struct TextWithDescription: View {
    var MainText: String
    var Description: String = "1개 이상"
    var body: some View {
        HStack {
            Text(MainText)
                .font(.system(size: 14))
                .foregroundStyle(.black)
            Spacer().frame(width: 8)
            Text(Description)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
    }
}
