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
        HStack(spacing: 8) {
            Text(MainText)
                .caption14SemiBold()
                .foregroundStyle(.gray700)
            Text(Description)
                .caption14Regular()
                .foregroundStyle(.gray500)
        }
    }
}
