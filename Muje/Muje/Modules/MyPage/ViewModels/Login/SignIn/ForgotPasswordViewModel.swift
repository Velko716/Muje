//
//  ForgotPasswordViewModel.swift
//  Muje
//
//  Created by 김진혁 on 9/4/25.
//

import Foundation

@Observable
final class ForgotPasswordViewModel {
    
    
    /// 비밀번호 재전송 이메일을 발송하는 메서드입니다.
    func sendPasswordReset(email: String) async throws {
        Task {
            do {
                try await FirebaseAuthManager.shared.sendPasswordReset(to: email)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
}
