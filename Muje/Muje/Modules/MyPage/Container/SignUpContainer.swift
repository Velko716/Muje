//
//  SignUpContainer.swift
//  Muje
//
//  Created by 김진혁 on 8/10/25.
//

import Foundation

@Observable
final class SignUpContainer {
    var emailVM = EmailVerificationViewModel()
    var userInfoVM = UserInfoInputViewModel(name: "", birthYear: "", gender: "", department: "", studentId: "")
    var phoneVM = PhoneVerificationViewModel()

    // FIXME: - Bool타입 변경
    var phoneNumber: String = ""
    var emailVerified: Bool = true
    var phoneVerified: Bool = true
    var termsAgreed: Bool = true
    var privacyAgreed: Bool = true
    
    func assembleUser(phone: String) -> User {
        let birth = Int(userInfoVM.birthYear) ?? 0
        return User(
            userId: UUID(),
            email: emailVM.emailText,
            name: userInfoVM.name,
            birthYear: birth,
            gender: userInfoVM.gender,
            department: userInfoVM.department,
            studentId: userInfoVM.studentId,
            emailVerified: emailVerified,
            termsAgreed: termsAgreed,
            privacyAgreed: privacyAgreed
        )
    }

    @discardableResult
    func createUserInFirestore(with phone: String) async throws -> User {
        let user = assembleUser(phone: phone)
        let created = try await FirestoreManager.shared.create(user)
        return created
    }
}
