//
//  MujeApp.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI
import FirebaseCore
import UserNotifications
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: - 휴대전화 인증 시 필요
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            // Firebase 인증 관련 알림이면 처리 완료로 반환
            completionHandler(.noData)
            return
        }

        // 다른 알림 처리 (예: FCM 등)
        completionHandler(.noData)
    }
}


@main
struct MujeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var signUpContainer = SignUpContainer()
    @StateObject var router: NavigationRouter = .init()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                        Task {
                            do {
                                let isNewUser = try await FirebaseAuthManager.shared.handleEmailSignInLink(
                                    url: url,
                                    inputEmail: FirebaseAuthManager.shared.email
                                )
                                
                                if isNewUser {
                                    if let uid = Auth.auth().currentUser?.uid {
                                        print("[Auth] New user UID: \(uid)")
                                        
                                        let newUser = User(
                                            userId: uid,
                                            email: FirebaseAuthManager.shared.email,
                                            name: "",
                                            birthYear: 0,
                                            gender: "",
                                            department: "",
                                            studentId: "",
                                            emailVerified: true,
                                            termsAgreed: false,
                                            privacyAgreed: false
                                        )
                                        let _ = try await FirestoreManager.shared.create(newUser) // 새 유저 이메일 인증 시 파이어베이스 등록
                                        router.push(to: .userInfoInputView(uuid: uid, email: FirebaseAuthManager.shared.email)) // 네비게이션 이동
                                        FirebaseAuthManager.shared.email = "" // 싱글톤 이메일 변수 초기화
                                    } else {
                                        print("[Auth] currentUser is nil. UID unavailable.")
                                    }
                                    print("이메일 새유저")
                                    
                                    //router.push(to: .userInfoInputView) // 회원 가입 뷰로 이동
                                } else {
                                    FirebaseAuthManager.shared.email = "" // 이메일 초기화
                                    // TODO: 로그인 완료, 키체인 유저 정보 입력, 마이 페이지 루트 뷰로 이동
                                }
                            } catch {
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    }
                .environment(signUpContainer)
                .environmentObject(router)
        }
    }
}
