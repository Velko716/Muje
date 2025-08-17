//
//  DeepLinkController.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import Foundation

final class DeepLinkController: ObservableObject {
    static let shared = DeepLinkController()
    @Published var pendingConversationId: UUID?   // 라우팅해야 할 대상
    private init() {}

    func handle(userInfo: [AnyHashable: Any]) {
        if let cid = userInfo["conversation_id"] as? String,
           let uuid = UUID(uuidString: cid) {
            DispatchQueue.main.async {
                self.pendingConversationId = uuid
            }
        }
    }
}
