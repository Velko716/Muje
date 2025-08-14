//
//  InboxView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct InboxListView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    
    var body: some View {
        Button {
//            let conversation = Conversation(
//                conversationId: UUID(),
//                participant1UserId: "", // 참여자1 ID (users 참조)
//                participant2UserId: "", // 참여자2 ID (users 참조)
//                postId: "", // 관련 공고 ID (posts 참조)
//                postTitle: "", // 공고 제목 (비정규화: posts.title)
//                postOrganization: "", // 단체명 (비정규화: posts.organization)
//                participant1Name: "", // 참여자1 이름 (비정규화: users.name)
//                participant1Role: .applicant,
//                participant2Name: "",
//                participant2Role: .recruiter
//            )
//            
//            Task {
//                let newChat = try await FirestoreManager.shared.create(conversation)
//                print("채팅기록 생성 : \(newChat)")
//            }
            router.push(to: .inboxView)
        } label: {
            Text("쪽지화면으로")
        }
    }
}

#Preview {
    InboxListView()
        .environmentObject(NavigationRouter())
}
