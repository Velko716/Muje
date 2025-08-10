//
//  FirebaseAuthManager.swift
//  Muje
//
//  Created by 김진혁 on 8/6/25.
//

import Foundation
import FirebaseAuth

/// Firebase Auth 호출을 한 곳에 모아두는 싱글톤 매니저
final class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    private init() {}
    
    var email: String = ""
    
    /// 현재 로그인 유저 이메일 조회
    var currentEmail: String {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return "" }
        
        return currentUserEmail
    }
    
    
    /// 현재 로그인 유저 로그아웃
    func currentUserSignOut() async throws {
        try Auth.auth().signOut()
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
}
