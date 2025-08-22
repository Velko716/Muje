//
//  IncomingMessageBubble.swift
//  Muje
//
//  Created by 김진혁 on 8/15/25.
//

import SwiftUI

struct IncomingMessageBubble: View {
    let text: String
    var time: Date? = nil
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                Text(text)
                    .bubble(color: Color(uiColor: .secondarySystemBackground), isBorder: true) // FIXME: - 컬러 수정
            }
            if let time {
                Text(time.hourMinute24)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        IncomingMessageBubble(text: "네 안녕하세요.", time: Date())
    }
    .padding(.horizontal, 16)
}
