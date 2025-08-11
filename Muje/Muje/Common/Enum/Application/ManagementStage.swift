//
//  ManagementStage.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import Foundation

enum ManagementStage {
  case submitted
  case interviewWaiting
  case reviewWaiting
  case reviewCompleted
  
  var displayName: String {
    switch self {
    case .submitted:
      return "지원서 제출"
    case .interviewWaiting:
      return "면접 대기"
    case .reviewWaiting:
      return "심사 대기"
    case .reviewCompleted:
      return "심사 완료"
    }
  }
}
