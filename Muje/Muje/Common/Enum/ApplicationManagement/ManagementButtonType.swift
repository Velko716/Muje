//
//  ManagementButtonType.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import Foundation

// MARK: - 지원서 제출, 면접 대기, 심사 대기 분기처리
enum ManagementButtonType {
  case submitted
  case interviewWaiting
  case reviewWaiting
  
  var LeftDisplayName: String {
    switch self {
    case .submitted:
      return "불합격"
    case .interviewWaiting:
      return "면접 취소"
    case .reviewWaiting:
      return "불합격"
    }
  }
  
  var RightDisplayName: String {
    switch self {
    case .submitted:
      return "면접 제안"
    case .interviewWaiting:
      return "면접 완료"
    case .reviewWaiting:
      return "합격"
    }
  }
}

// MARK: - 심사 완료 분기처리
enum NotifyButtonType: String {
  case allNotify
  case selectedNotify
  
  var dispayName: String {
    switch self {
    case .allNotify:
      return "모두에게 심사 결과 알리기"
    case .selectedNotify:
      return "심사 결과 알리기"
    }
  }
}
