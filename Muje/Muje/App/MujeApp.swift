//
//  MujeApp.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 알림 권한 요청 + 델리게이트 설정
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Notification permission granted:", granted)
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications() // ← 반드시 호출
            }
        }
        
        Messaging.messaging().delegate = self
        return true
    }
    
    // APNs 토큰 등록 확인 (스위즐링 ON이면 자동 전달되지만, 있으면 더 확실)
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs deviceToken:", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
        // 스위즐링 OFF(Info.plist에 FirebaseAppDelegateProxyEnabled = NO)라면 아래 줄 꼭 필요
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    // 포그라운드 표시
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // 탭한 뒤 라우팅
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Tapped notification userInfo:", userInfo)
        // userInfo["conversation_id"] 활용해 채팅방으로 이동
        completionHandler()
    }
    
    // 최신 FCM 토큰 콜백
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token(updated):", fcmToken ?? "nil")
        // Firestore 저장 (아래 함수 참고)
        if let token = fcmToken { Task { await saveTokenToFirestore(token) } }
    }
    
    private func saveTokenToFirestore(_ token: String) async {
        guard let uid = FirebaseAuthManager.shared.currentUser?.userId else { return }
        let ref = Firestore.firestore()
            .collection("users").document(uid)
            .collection("fcm_tokens").document(token) // 문서 ID=토큰 문자열
        do {
            try await ref.setData([
                "created_at": FieldValue.serverTimestamp(),
                "platform": "ios"
            ], merge: true)
            print("Saved FCM token to Firestore")
        } catch {
            print("Save token error:", error)
        }
    }
}


@main
struct MujeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var router: NavigationRouter = .init()
    @StateObject var push = NotificationCoordinator()
    
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
            .environmentObject(push)
            .onReceive(NotificationCenter.default.publisher(for: .openConversation)) { n in
                guard let uuid = n.object as? UUID else { return }
                router.push(to: .inboxView(conversationId: uuid))
            }
            // FIXME: - (임시) 수정
            .onChange(of: scenePhase) { phase, _ in
                if phase == .active { UNUserNotificationCenter.current().setBadgeCount(0) } // 뱃지 초기화
            }
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

final class NotificationCoordinator: ObservableObject {}
extension Notification.Name { static let openConversation = Notification.Name("openConversation") }
