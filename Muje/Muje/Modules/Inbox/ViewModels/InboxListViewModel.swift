//
//  InboxListViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/16/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
final class InboxListViewModel {
    var conversations: [Conversation] = []
    let currentUserId: String
    var isLoading: Bool = false
    
    init(currentUserId: String) { self.currentUserId = currentUserId }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            conversations = try await FirestoreManager.shared.fetchConversationsForUser(currentUserId)
        } catch {
            conversations = []
        }
    }
    
    func createConversation(
        postId: String,
        postTitle: String,
        postOrganization: String,
        participant1: (id: String, name: String, role: ParticipantRole),
        participant2: (id: String, name: String, role: ParticipantRole)
    ) async throws -> Conversation {
        let convo = Conversation(
            conversationId: UUID(),
            participant1UserId: participant1.id,
            participant2UserId: participant2.id,
            postId: postId,
            postTitle: postTitle,
            postOrganization: postOrganization,
            participant1Name: participant1.name,
            participant1Role: participant1.role,
            participant2Name: participant2.name,
            participant2Role: participant2.role
        )
        let saved = try await FirestoreManager.shared.create(convo)
        return saved
    }
    
    // 셀에서 표시할 상대방 이름 구하기
    func otherName(for convo: Conversation) -> String {
        if convo.participant1UserId == currentUserId { return convo.participant2Name }
        else { return convo.participant1Name }
    }
}
