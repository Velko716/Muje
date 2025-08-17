//
//  DetailModalButtonType.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import Foundation

enum DetailModalButtonType {
  case twoButton(left: String, right: String)
  case singleButton(title: String)
  
  static func from(_ status: ApplicationStatus) -> DetailModalButtonType {
    switch status {
    case .submitted:
      return .twoButton(left: "불합격", right: "면접 제안")
    case .interviewWaiting:
      return .twoButton(left: "면접 취소", right: "면접 완료")
    case .reviewWaiting:
      return .twoButton(left: "불합격", right: "합격")
    case .reviewCompleted:
      return .singleButton(title: "심사 결과 알리기")
    }
  }
}

extension ApplicationStatus {
  var modalButtonType: DetailModalButtonType {
    return DetailModalButtonType.from(self)
  }
}
