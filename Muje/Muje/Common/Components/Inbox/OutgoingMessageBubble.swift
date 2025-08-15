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
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 8)
            }
            HStack {
                Text(text)
                    .font(.body) // FIXME: - 폰트 수정
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.12)) // FIXME: - 컬러 수정
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
