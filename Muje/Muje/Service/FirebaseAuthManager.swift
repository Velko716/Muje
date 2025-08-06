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
}
