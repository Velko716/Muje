//
//  PhoneVerificationViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/8/25.
//

import Foundation
import FirebaseAuth

@Observable
class PhoneVerificationViewModel {
    
    var verificationID: String?
    
    init(
        verificationID: String? = nil
    ) {
        self.verificationID = verificationID
    }
    
    func formatPhoneNumberToKorean(_ phoneNumber: String) -> String {
        let withoutFirstCharacter = String(phoneNumber.dropFirst())
        return "+82" + withoutFirstCharacter
    }
    
    func requestPhoneVerification(phoneNumber: String) {
        Task {
            do {
                self.verificationID = try await FirebaseAuthManager.shared.verifyPhoneNumberAsync(phoneNumber: phoneNumber)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
