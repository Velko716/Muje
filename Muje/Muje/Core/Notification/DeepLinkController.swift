//
//  DeepLinkController.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import Foundation

@MainActor
final class DeepLinkController: ObservableObject {
    static let shared = DeepLinkController()
    @Published var pendingConversationId: UUID? = nil

    /// 푸시 userInfo나 런치옵션에서 넘어온 userInfo 처리
    func handle(userInfo: [AnyHashable: Any]) {
        // FCM Functions에서 data에 넣은 키: "conversation_id"
        let val = (userInfo["conversation_id"] as? String)
                ?? (userInfo["cid"] as? String)           // 혹시 대비
                ?? (userInfo["conversationId"] as? String) // 혹시 대비
        guard let s = val, let uuid = UUID(uuidString: s) else {
            print("DeepLinkController: invalid conversation_id in userInfo:", userInfo)
            return
        }
        pendingConversationId = uuid
    }
}
