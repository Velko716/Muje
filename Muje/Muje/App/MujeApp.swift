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
    @StateObject private var router: NavigationRouter = .init()

    @State private var isReady = false
    @State private var bootError: String?

    var body: some Scene {
        WindowGroup {
            Group {
                if isReady {
                    RootView()
                } else {
                    ProgressView("로딩 중...") // FIXME: - 스플래시 대체
                }
            }
            // 앱 최초 부팅 시 사용자 세션/프로필 로드
            .task { await boot() }
            // 이메일 링크 딥링크 처리
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
                                _ = try await FirestoreManager.shared.create(newUser)

                                // 뷰 전환이 즉시 가능하도록 먼저 준비 완료 표시
                                isReady = true
                                // 회원정보 입력 화면으로 이동
                                router.push(to: .userInfoInputView(uuid: uid, email: FirebaseAuthManager.shared.email))
                                // 싱글톤 이메일 초기화
                                FirebaseAuthManager.shared.email = ""
                            } else {
                                print("[Auth] currentUser is nil. UID unavailable.")
                                isReady = true
                            }
                            print("이메일 새유저")
                        } else {
                            // 기존 유저 로그인 완료
                            FirebaseAuthManager.shared.email = ""
                            isReady = true
                            // 필요 시 여기서 라우팅 추가
                        }
                    } catch {
                        print("error: \(error.localizedDescription)")
                        isReady = true
                    }
                }
            }
            .environmentObject(router)
        }
    }

    // MARK: - 현재 유저 로드
    @MainActor
    private func boot() async {
        do {
            if let uid = Auth.auth().currentUser?.uid {
                print("현재 접속자 UID: \(uid)")
                let user: User = try await FirestoreManager.shared.get(uid, from: .user)
                FirebaseAuthManager.shared.currentUser = user
                print("FirebaseAuthManager \(String(describing: FirebaseAuthManager.shared.currentUser))")
            } else {
                print("비로그인 상태")
            }
            isReady = true
        } catch {
            bootError = error.localizedDescription
            print("부팅 오류: \(bootError!)")
            // 오류가 있어도 진입은 가능하게
            isReady = true
        }
    }
}
