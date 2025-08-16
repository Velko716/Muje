//
//  ConversationRow.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import SwiftUI

struct ConversationRow: View {
    let conversation: Conversation
    let currentUserId: String

    var otherName: String {
        conversation.participant1UserId == currentUserId
            ? conversation.participant2Name
            : conversation.participant1Name
    }
    
    private var lastLine: String {
        let body = (conversation.lastMessageText ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
        
        guard !body.isEmpty else { return "대화를 시작해보세요" }
        
        let prefix = (conversation.lastSenderUserId == currentUserId) ? "나: " : ""
        return prefix + body
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                
                Text(otherName)
                    .font(Font.system(size: 18))
                    .foregroundStyle(Color.black)
                
                Text(conversation.postTitle) 
                    .font(Font.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                // 생성/업데이트 시간 중 있는 값 표시
                let time = conversation.updatedAt?.dateValue() ?? conversation.createdAt?.dateValue()
                if let date = time {
                    Text(date.listTimeLabel())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(lastLine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    ConversationRow(
        conversation: .init(
            conversationId: UUID(),
            participant1UserId: "",
            participant2UserId: "",
            postId: "",
            postTitle: "",
            postOrganization: "",
            participant1Name: "",
            participant1Role: .applicant,
            participant2Name: "",
            participant2Role: .recruiter
        ),
        currentUserId: ""
    )
}
