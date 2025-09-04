//
//  FirebaseAuthManager.swift
//  Muje
//
//  Created by 김진혁 on 8/6/25.
//

import Foundation
import FirebaseAuth

/// Firebase Auth 호출을 한 곳에 모아두는 싱글톤 매니저
final class FirebaseAuthManager: ObservableObject {
    static let shared = FirebaseAuthManager()
    private init() {}
    
    var email: String = ""
    
    
    /// 파이어베이스 이메일 인증 여부 확인 변수입니다. (딥 링크로 앱에 다시 들어올 때, UI 갱신을 위해서 구현)  🤔 여기 한 번 살펴보기...! (DI, Actor 등등)
    @Published var emailVerified: Bool = false
    
    
    /// 현재 로그인 유저 이메일 조회
    var currentEmail: String {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return "" }
        
        return currentUserEmail
    }
    
    /// 현재 로그인 유저 입니다. 🤔 여기 한 번 살펴보기...! (DI, Actor 등등)
    @Published var currentUser: User?
    
    
    /// 현재 사용자를 업데이트 해주는 함수입니다.
    func setCurrentUser(_ user: User?) {
        DispatchQueue.main.async {
            self.currentUser = user
        }
    }
    
    /// 현재 파이어베이스에 로그인된 사용자를 로그아웃 기능을 수행하는 메서드입니다.
    func currentUserSignOut() async throws {
        try Auth.auth().signOut()
        await MainActor.run {
            self.currentUser = nil
        }
    }
    
    /// 이메일로 인증메일을 전송하는 메서드입니다.
    func sendSignInLink(to email: String) async throws {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://muje-a649a.web.app/index.html") // /index.html
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier ?? "")
        
        try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
    }
    
    /// 딥 링크 로그인 인증 로직을 처리하는 메서드입니다.
    func handleEmailSignInLink(url: URL, inputEmail: String) async throws -> Bool {
        guard url.scheme == "muje",
              url.host == "email-verified",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let oobCode = queryItems.first(where: { $0.name == "oobCode" })?.value,
              let mode = queryItems.first(where: { $0.name == "mode" })?.value,
              mode == "signIn"
        else {
            throw FirebaseAutoError.invalidLink
        }
        
        var signInLink = "https://muje-a649a.web.app/?oobCode=\(oobCode)&mode=signIn"
        
        if let apiKey = queryItems.first(where: { $0.name == "apiKey" })?.value {
            signInLink += "&apiKey=\(apiKey)"
        }
        
        if let continueUrl = queryItems.first(where: { $0.name == "continueUrl" })?.value {
            signInLink += "&continueUrl=\(continueUrl)"
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: inputEmail, link: signInLink)
            let isNewUser = result.additionalUserInfo?.isNewUser ?? false
            return isNewUser
        } catch {
            throw FirebaseAutoError.firebaseError(error)
        }
    }
    
    /// 이메일과 패스워드로 로그인을 처리하는 메서드입니다.
    func signInWithEmailPassword(email: String, password: String) async throws {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = Auth.auth().currentUser?.uid ?? ""
            let user: User = try await FirestoreManager.shared.get(uid, from: .user)
            await MainActor.run { self.currentUser = user }
        } catch let nsErr as NSError {
            let code = AuthErrorCode(_bridgedNSError: nsErr)
            switch code {
            case .invalidEmail:
                throw AppAuthError.invalidEmail
            case .wrongPassword:
                throw AppAuthError.wrongPassword
            case .userNotFound:
                throw AppAuthError.userNotFound
            case .userDisabled:
                throw AppAuthError.userDisabled
            case .tooManyRequests:
                throw AppAuthError.tooManyRequests
            case .networkError:
                throw AppAuthError.networkError
            default:
                throw AppAuthError.unknown(nsErr)
            }
        }
    }
    
    
    /// 핸드폰 인증으로 로그인 하는 메서드입니다.
    func verifyPhoneNumberAsync(phoneNumber: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let verificationID = verificationID else {
                        continuation.resume(throwing: NSError(
                            domain: "PhoneAuth",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Verification ID is nil"]
                        ))
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "verificationID") // FIXME: - 파베 공식 문서 방법
                    continuation.resume(returning: verificationID)
                }
        }
    }
    
    /// 전화번호 인증 코드 검증 후, 성공 시 true / 실패 시 false 반환
    func verifyPhoneCodeAndSignOut(id verificationID: String, code verificationCode: String) async throws -> Bool {
        do {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            // Firebase Auth 로그인 시도
            _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AuthDataResult, Error>) in
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let result = result {
                        continuation.resume(returning: result)
                    } else {
                        continuation.resume(throwing: NSError(
                            domain: "PhoneAuth",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown signIn state"]
                        ))
                    }
                }
            }
            
            // 성공 시 로그아웃
            try Auth.auth().signOut()
            return true
        } catch {
            print("인증 실패: \(error.localizedDescription)")
            // 혹시 로그인 상태가 남아있으면 방어적으로 로그아웃 시도
            do { try Auth.auth().signOut() } catch { }
            return false
        }
    }
    
    
    /// 현재 로그인한 유저의 Firebase Authentication을 삭제하는 메서드 입니다. (회원 탈퇴 기능을 수행함)
    /// 유저가 작성한 파이어스토어에 저장된 데이터는 연쇄삭제 되지 않도록 구현했지만, 추후 변경될 수도 있습니다.
    /*
     현재 로그인 방식으로 회원 탈퇴 기능을 수행하지 못함.
     <에러 코드>
     error: This operation is sensitive and requires recent authentication. Log in again before retrying this request.
     파이어베이스에서 자체적으로 회원 탈퇴를 막고 있어서, 탈퇴 하기 전에 사용자의 인증을 한 번 받아야 함.
     근데 현재 우리 앱의 로그인 인증 과정중에는 패스워드가 없기 때문에 회원 탈퇴를 구현할 수 없음.
     그러므로 로그인 과정 중에 패스워드를 추가해야하고
     비밀번호 찾기 등 기능들을 여러 추가해야 합니다!
     */
    func deleteAccountWithEmailPassword(email: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        let cred = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await user.reauthenticate(with: cred)
            try await user.delete()
            self.currentUser = nil
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
    /// Firebase Auth 패스워드를 설정하는 메서드 입니다. (회원 가입 뷰 사용)
    func setInitialPassword(_ newPassword: String, email: String) async throws {
        guard let user = Auth.auth().currentUser else { throw AppAuthError.notLoggedIn }
        
        do {
            // 1) 가장 단순: 이미 email provider가 붙어있다면 비번을 업데이트
            try await user.updatePassword(to: newPassword)
            try? await user.reload()
            return
        } catch let nsErr as NSError {
            // 일부 케이스는 link 로 해결
            let code = AuthErrorCode(_bridgedNSError: nsErr)
            
            if code == .operationNotAllowed {
                // Firebase Console > Authentication > Sign-in method 에서
                // Email/Password 를 활성화해야 로그인에 비번 사용 가능
                throw AppAuthError.operationNotAllowed
            }
            if code == .requiresRecentLogin {
                throw AppAuthError.requiresRecentLogin
            }
            if code == .weakPassword {
                throw AppAuthError.weakPassword
            }
            
            // 2) provider 상태에 따라 link 시도 (Apple/Google만 있던 계정에 비번 추가하는 시나리오 등)
            do {
                let credential = EmailAuthProvider.credential(withEmail: email, password: newPassword)
                _ = try await user.link(with: credential)
                try? await user.reload()
            } catch let linkErr as NSError {
                let linkCode = AuthErrorCode(_bridgedNSError: linkErr)
                if linkCode == .credentialAlreadyInUse {
                    // 이미 비번이 설정된 계정일 수 있음 → updatePassword 로 재시도 유도
                }
                throw linkErr
            }
        }
    }
    
}
