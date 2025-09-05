//
//  FirebaseAutoError.swift
//  Muje
//
//  Created by 김진혁 on 8/6/25.
//

import Foundation

enum FirebaseAutoError: LocalizedError {
    case invalidLink
    case unknown
    case firebaseError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidLink:
            return "유효하지 않은 인증 링크입니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .firebaseError(let error):
            return error.localizedDescription
        }
    }
}

/// Firebase Auth 패스워드 설정 에러
enum AppAuthError: Error {
    case notLoggedIn
    case operationNotAllowed // 콘솔에서 Email/Password 비활성화
    case requiresRecentLogin // 세션 오래됨 → 재인증 필요
    case weakPassword // 6자 미만 등
    
    
    // 이메일/비번 로그인용 에러
    case invalidEmail
    case wrongPassword
    case userNotFound
    case userDisabled
    case tooManyRequests
    case networkError
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        case .notLoggedIn:
            return "로그인이 필요해요. 다시 로그인한 뒤 시도해 주세요."
        case .operationNotAllowed:
            return "이메일/비밀번호 로그인이 비활성화되어 있어요. 잠시 후 다시 시도하거나 관리자에게 문의해 주세요."
        case .requiresRecentLogin:
            return "보안상의 이유로 다시 로그인해 주세요."
        case .weakPassword:
            return "비밀번호가 너무 짧아요. 6자 이상으로 설정해 주세요."
        case .invalidEmail:
            return "이메일 형식이 올바르지 않아요."
        case .wrongPassword:
            return "비밀번호가 올바르지 않아요."
        case .userNotFound:
            return "해당 이메일의 계정을 찾을 수 없어요."
        case .userDisabled:
            return "비활성화된 계정이에요. 관리자에게 문의해 주세요."
        case .tooManyRequests:
            return "요청이 너무 많아요. 잠시 후 다시 시도해 주세요."
        case .networkError:
            return "네트워크 오류가 발생했어요. 연결을 확인해 주세요."
        case .unknown(let underlying):
            return "\(underlying.localizedDescription)"
        }
    }
}
