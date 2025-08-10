//
//  MyPageViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation

@Observable
final class EmailVerificationViewModel {
    
    var emailText: String = ""
    
    func sendVerificationEmail() {
        Task {
            do {
                try await FirebaseAuthManager.shared.sendSignInLink(to: self.emailText) // FIXME: - ⚠️ 추후 이메일 @jbnu.ac.kr 고정
                FirebaseAuthManager.shared.email = self.emailText
                
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
