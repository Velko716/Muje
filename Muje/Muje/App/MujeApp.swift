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
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
        }
        
        // 🔴 콜드 스타트로 알림 탭해 들어온 경우
        if let remote = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            DeepLinkController.shared.handle(userInfo: remote)
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
    
    // 포그라운드 표시 제어 (이미 구현해 둔 그대로 OK)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let cidString = userInfo["conversation_id"] as? String
        if UIApplication.shared.applicationState == .active,
           let active = CurrentChatContext.shared.activeConversationId,
           active.uuidString == cidString {
            completionHandler([])            // 현재 보고 있는 방이면 무음/무배너
            return
        }
        completionHandler([.banner, .sound, .badge]) // 그 외에는 정상 표시
    }
    
    // 🔴 알림 배너/알림센터 탭 시
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        DeepLinkController.shared.handle(userInfo: userInfo) // ← 여기서 값만 저장
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
    @StateObject private var deepLink = DeepLinkController.shared
    @StateObject private var unreadBadge = UnreadBadgeStore()
    
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
                            if let uid = Auth.auth().currentUser?.uid {
                                do {
                                    let user: User = try await FirestoreManager.shared.get(uid, from: .user)
                                    await MainActor.run {
                                        FirebaseAuthManager.shared.currentUser = user
                                        unreadBadge.start(for: uid) // 뱃지 초기화
                                        self.isReady = true
                                        FirebaseAuthManager.shared.email = ""
                                        router.popToRootView() // FIXME: - 팝 루트가 되니까 쪽지 리스트쪽이 안채워짐. 풀 스크린 스택 교체 필요
                                    }
                                } catch {
                                    // 문서가 없거나 에러여도 앱은 열 수 있게 처리
                                    print("Existing user load error:", error)
                                    await MainActor.run {
                                        self.isReady = true
                                        FirebaseAuthManager.shared.email = ""
                                        router.popToRootView()
                                    }
                                }
                            } else {
                                await MainActor.run {
                                    self.isReady = true
                                    FirebaseAuthManager.shared.email = ""
                                    router.popToRootView()
                                }
                            }
                            FirebaseAuthManager.shared.email = ""
                            isReady = true
                            
                        }
                    } catch {
                        print("error: \(error.localizedDescription)")
                        isReady = true
                    }
                }
            }
            .environmentObject(router)
            .environmentObject(push)
            .environmentObject(unreadBadge)
            .environmentObject(deepLink)
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
                unreadBadge.start(for: uid)
                print("FirebaseAuthManager \(String(describing: FirebaseAuthManager.shared.currentUser))")
            } else {
                unreadBadge.stop()
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


