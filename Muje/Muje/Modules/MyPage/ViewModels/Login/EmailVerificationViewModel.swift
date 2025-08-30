//
//  MyPageViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation

@Observable
final class EmailVerificationViewModel {
    
    
    func sendVerificationEmail(emailText: String) {
        Task {
            do {
                try await FirebaseAuthManager.shared.sendSignInLink(to: emailText) // FIXME: - ⚠️ 추후 이메일 @jbnu.ac.kr 고정
                FirebaseAuthManager.shared.email = emailText
                
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
