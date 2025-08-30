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
    
    // FIXME: - 현재 로그인한 유저의 Firebase Authentication을 삭제
    /*
     현재 로그인 방식으로 회원 탈퇴 기능을 수행하지 못함.
     <에러 코드>
     error: This operation is sensitive and requires recent authentication. Log in again before retrying this request.
     파이어베이스에서 자체적으로 회원 탈퇴를 막고 있어서, 탈퇴 하기 전에 사용자의 인증을 한 번 받아야 함.
     근데 현재 우리 앱의 로그인 인증 과정중에는 패스워드가 없기 때문에 회원 탈퇴를 구현할 수 없음.
     그러므로 로그인 과정 중에 패스워드를 추가해야하고
     비밀번호 찾기 등 기능들을 여러 추가해야 합니다!
     */
    func deleteAuth() async throws {
        do {
            try await FirebaseAuthManager.shared.deleteAccountWithEmailPassword(email: "wlsgurrla716@naver.com", password: "123456") // FIXME: - 파라미터 수정하기
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
