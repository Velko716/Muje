//
//  ConfirmationModalType.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import Foundation

enum ConfirmationModalType: Identifiable {
  var id: String {
    switch self {
    case .reject(let name):
      return "\(name)"
    case .promote(let name):
      return "\(name)"
    case .completeInterview(let name):
      return "\(name)"
    case .pass(let name):
      return "\(name)"
    case .cancelInterview(let name):
      return "\(name)"
    case .notify(let name):
      return "\(name)"
    }
  }
  
  case reject(String) // 불합격
  case promote(String) // 면접 제안
  case completeInterview(String) // 면접 완료
  case pass(String) // 합격
  case cancelInterview(String) // 면접 취소
  case notify(String) // 알림 발송
  
  var title: String {
    switch self {
    case .reject(let name):
      return "\(name)을(를)\n불합격 처리 하시겠어요?"
    case .promote(let name):
      return "\(name)에게\n면접을 제안하시겠어요?"
    case .completeInterview(let name):
      return "\(name)을(를)\n면접 완료 처리할까요?"
    case .pass(let name):
      return "\(name)을(를)\n최종 합격 처리할까요?"
    case .cancelInterview(let name):
      return "\(name)에게\n면접 제안을 취소하시겠어요?"
    case .notify(let name):
      return "\(name)에게\n심사 결과를 공유하시겠어요?"
    }
  }
  
  var buttonText: String {
    switch self {
    case .reject:
      return "불합격"
    case .promote:
      return "면접 제안"
    case .completeInterview:
      return "면접 완료"
    case .pass:
      return "합격"
    case .cancelInterview:
      return "면접 제안 취소"
    case .notify:
      return "심사 결과 공유"
    }
  }
}
