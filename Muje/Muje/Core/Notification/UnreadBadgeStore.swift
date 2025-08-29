//
//  UnreadBadgeStore.swift
//  Muje
//
//  Created by 김진혁 on 8/21/25.
//

import Foundation
import UserNotifications
import FirebaseFirestore

final class UnreadBadgeStore: ObservableObject {
    @Published var total: Int = 0
    private var listener: ListenerRegistration?

    func start(for userId: String) {
        stop() // 중복 방지

        listener = FirestoreManager.shared.listenConversationsForUser(userId) { list in
            let sum = list.reduce(0) { acc, convo in
                acc + (convo.unread?[userId] ?? 0)
            }
            DispatchQueue.main.async {
                self.total = sum
                Self.setAppBadge(sum)
            }
        }
    }

    func stop() {
        listener?.remove()
        listener = nil
        DispatchQueue.main.async {
            self.total = 0
            Self.setAppBadge(0)
        }
    }

    private static func setAppBadge(_ count: Int) {
        if #available(iOS 17.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(count) { err in
                if let err { print("setBadgeCount error:", err) }
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
