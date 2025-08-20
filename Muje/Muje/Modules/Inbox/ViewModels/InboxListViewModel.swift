//
//  InboxListViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/16/25.
//

import Foundation
import FirebaseFirestore

@Observable
final class InboxListViewModel {
    var conversations: [Conversation] = []
    let currentUserId: String
    var isLoading: Bool = false
    
    private var listener: ListenerRegistration?
    
    init(currentUserId: String) { self.currentUserId = currentUserId }
    
    // 실시간 시작
    func start() {
        stop()
        isLoading = true
        listener = FirestoreManager.shared.listenConversationsForUser(currentUserId) { [weak self] list in
            guard let self else { return }
            self.conversations = list
            self.isLoading = false
        }
    }
    
    // 해제
    func stop() {
        listener?.remove()
        listener = nil
    }
    
    // 기존 생성 로직은 그대로
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

    func otherName(for convo: Conversation) -> String {
        convo.participant1UserId == currentUserId ? convo.participant2Name : convo.participant1Name
    }
    
    // FIXME: - 더 좋은 방법으로 수정하기 (초기 파이어베이스 리셋 설정으로 값을 초기화 == 0)
    func resetCount(conversationId: UUID) async {
        Task { try? await FirestoreManager.shared
                .markConversationRead(conversationId: conversationId, userId: self.currentUserId)
        }
    }
}
