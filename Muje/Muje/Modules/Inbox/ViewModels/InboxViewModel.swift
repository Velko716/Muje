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
    
    var showBlockedAlert: Bool = false
    
    private var listener: ListenerRegistration?
    
    private var isLoadingMore = false
    
    
    init(conversationId: UUID, currentUserId: String) {
        self.conversationId = conversationId
        self.currentUserId = currentUserId
    }
    
    var reportedUserId: String = ""
    
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
        guard !isLoadingMore, let cursor = oldestCursor else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let (more, newCursor) = try await FirestoreManager.shared.fetchMoreMessages(
                conversationId: conversationId,
                after: cursor
            )
            messages.insert(contentsOf: more, at: 0)
            oldestCursor = newCursor

            // 더 불러올 페이지가 없으면 트리거 비활성화
            if more.isEmpty || newCursor == nil {
                oldestCursor = nil
            }
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
    
    func resetCount() async {
        Task { try? await FirestoreManager.shared
                .markConversationRead(conversationId: self.conversationId, userId: self.currentUserId)
        }
    }
    
    
    /// 상대방의 userID를 가져오는 메서드 입니다.
    func otherUserId(conversationId: String) async throws {
        let conversation: Conversation = try await FirestoreManager.shared.get(
            conversationId,
            from: .conversations
        )
        let arr = conversation.participants.filter { $0 != FirebaseAuthManager.shared.currentUser?.userId ?? "" }
        self.reportedUserId = arr.first ?? ""
    }
   
    
    /// 대화 문서에서 상대방 UID를 확보 (participant1/2 혹은 participants 배열 지원) + 차단
    func ensureOtherUserId(conversationId: String) async throws {
        let conversation: Conversation = try await FirestoreManager.shared.get(
            conversationId,
            from: .conversations
        )
        
        let arr = conversation.participants.filter { $0 != FirebaseAuthManager.shared.currentUser?.userId ?? "" }
        
        try await FirestoreManager.shared.addBlock(
            for: FirebaseAuthManager.shared.currentUser?.userId ?? "",
            blockedUserId: arr.first ?? ""
        )
    }
}
