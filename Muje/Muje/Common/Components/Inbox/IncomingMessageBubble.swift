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
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 18)
                    .background(Color(uiColor: .secondarySystemBackground)) // FIXME: - 컬러 수정
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.secondary.opacity(0.15), lineWidth: 1)
                    )
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
