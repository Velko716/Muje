//
//  LoginViewModel.swift
//  Muje
//
//  Created by 김진혁 on 9/3/25.
//

import Foundation

@Observable
final class LoginViewModel {
    
    
    func signInWithEmailPassword(email: String, password: String) async throws {
        try await FirebaseAuthManager.shared.signInWithEmailPassword(email: email, password: password)
    }
}
