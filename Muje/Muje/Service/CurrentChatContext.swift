//
//  CurrentChatContext.swift
//  Muje
//
//  Created by 김진혁 on 8/21/25.
//

import Foundation

// MARK: - 현재 있는 채팅방에서 알림이 울리지 않게 하려고 구현
@Observable
final class CurrentChatContext {
    static let shared = CurrentChatContext()
    var activeConversationId: UUID? = nil
}
