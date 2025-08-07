//
//  MujeApp.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct MujeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var router: NavigationRouter = .init()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                        Task {
                            do {
                                let isNewUser = try await FirebaseAuthManager.shared.handleEmailSignInLink(url: url, inputEmail: "rlawlsgur7@postech.ac.kr") // FIXME: - 이메일 수정
                                
                                if isNewUser {
                                    router.push(to: .userInfoInputView) // 회원 가입 뷰로 이동
                                } else {
                                    // TODO: 로그인 완료, 키체인 유저 정보 입력, 마이 페이지 루트 뷰로 이동
                                }
                            } catch {
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    }
            
                .environmentObject(router)
        }
    }
}
