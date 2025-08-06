//
//  MyPageViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation

@Observable
final class EmailVerificationViewModel {
    
    
    
    
    func sendVerificationEmail() {
        Task {
            do {
                try await FirebaseAuthManager.shared.sendSignInLink(to: "rlawlsgur7@postech.ac.kr")
            } catch {
                print("error: \(error)")
            }
        }
    }
}
