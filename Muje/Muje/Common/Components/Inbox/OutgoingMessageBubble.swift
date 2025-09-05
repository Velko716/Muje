//
//  OutgoingMessageBubble.swift
//  Muje
//
//  Created by 김진혁 on 8/15/25.
//

import SwiftUI

struct OutgoingMessageBubble: View {
    let text: String
    var time: Date? = nil

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if let time {
                Text(time.hourMinute24)
                    .font(Font.pretendard(type: .regular, size: 12))
                    .foregroundStyle(Color.gray400)
                    .padding(.trailing, 8)
            }
            HStack {
                Text(text)
                    .bubble(color: Color.gray50, isBorder: false)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// 예시
#Preview {
    VStack {
        OutgoingMessageBubble(text: "안녕하세요!", time: Date())
        OutgoingMessageBubble(text: "휴학생은 가능하고, 졸업생은 받지 않아요. 죄송합니다🥲", time: Date())
    }
    .padding(.horizontal, 16)
}
