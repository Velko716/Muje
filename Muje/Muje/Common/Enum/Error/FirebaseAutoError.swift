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
}
