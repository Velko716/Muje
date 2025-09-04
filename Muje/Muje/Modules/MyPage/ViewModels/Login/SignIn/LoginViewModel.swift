//
//  LoginViewModel.swift
//  Muje
//
//  Created by 김진혁 on 9/3/25.
//

import Foundation

@Observable
final class LoginViewModel {
    
    
    func signInWithEmailPassword(email: String, password: String) async {
        do {
            try await FirebaseAuthManager.shared.signInWithEmailPassword(email: email, password: password)
        } catch let err as AppAuthError {
            switch err {
            case .invalidEmail:
                print("이메일 형식이 올바르지 않습니다.")
            case .wrongPassword:
                print("비밀번호가 올바르지 않습니다.")
            case .userNotFound:
                print("해당 이메일의 계정을 찾을 수 없습니다.")
            case .userDisabled:
                print("비활성화된 계정입니다. 관리자에게 문의해주세요.")
            case .tooManyRequests:
                print("시도가 너무 많습니다. 잠시 후 다시 시도해주세요.")
            case .networkError:
                print("네트워크 오류가 발생했습니다. 연결을 확인해주세요.")
            default:
                print("로그인 중 문제가 발생했습니다. 다시 시도해주세요.")
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
