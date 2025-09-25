//
//  MyPageViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/25/25.
//

import SwiftUI

@Observable
final class MyPageViewModel {
    
    
    // MARK: - 로그아웃 기능
    func currentUserSignOut() async {
        Task {
            do {
                try await FirebaseAuthManager.shared.currentUserSignOut()
            } catch {
                print("로그아웃 실패:\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - iOS앱 알림 설정 화면으로 이동
    func openAppNotificationSettings(using openURL: OpenURLAction, onComplete: ((Bool) -> Void)? = nil) {
        let urlString: String
        if #available(iOS 16.0, *) {
            urlString = UIApplication.openNotificationSettingsURLString
        } else {
            urlString = UIApplication.openSettingsURLString
        }
        guard let url = URL(string: urlString) else {
            onComplete?(false); return
        }
        openURL(url) { accepted in
            onComplete?(accepted)
        }
    }
}
