//
//  InboxViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
@Observable
final class InboxViewModel {
    
    var messages: [Message] = []
    var oldestCursor: DocumentSnapshot?
    
    let conversationId: UUID
    let currentUserId: String
    
    private var listener: ListenerRegistration?
    
    init(conversationId: UUID, currentUserId: String) {
        self.conversationId = conversationId
        self.currentUserId = currentUserId
    }
    
    // MARK: - 쪽지
    
    func start() {
        stop()
        listener = FirestoreManager.shared.listenMessages(
            conversationId: conversationId,
            onChange: { [weak self] page, cursor in
                guard let self else { return }
                self.messages = page
                self.oldestCursor = cursor
            }
        )
    }
    
    func stop() {
        listener?.remove()
        listener = nil
    }
    
    func loadMore() async {
        guard let cursor = oldestCursor else { return }
        do {
            let (more, newCursor) = try await FirestoreManager.shared.fetchMoreMessages(
                conversationId: conversationId,
                after: cursor
            )
            messages.insert(contentsOf: more, at: 0)
            oldestCursor = newCursor
        } catch {
            print("loadMore error:", error)
        }
    }
    
    func send(text: String) async {
        do {
            try await FirestoreManager.shared.sendMessage(
                conversationId: conversationId,
                senderUserId: currentUserId,
                text: text
            )
        } catch {
            print("send error:", error)
        }
    }
    
    
    // MARK: - 액션 시트
    func leave() async {
        do {
            try await FirestoreManager.shared.leaveConversation(
                conversationId: conversationId,
                userId: currentUserId
            )
        } catch {
            print("leave error:", error)
        }
    }
    
}
