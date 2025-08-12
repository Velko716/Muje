//
//  ApplicationStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation
import SwiftUI

enum ApplicationStatus: String, Codable {
    case submitted = "지원서 제출됨"
    case interviewWaiting = "면접 대기 중"
    case reviewWaiting = "심사 대기 중"
    case reviewCompleted = "심사 완료됨"
  
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

extension Application {
  var detailedStatusText: String {
    let status = ApplicationStatus(rawValue: self.status)
    
    switch status {
    case .submitted:
      return "지원서 제출 완료"
    case .interviewWaiting:
      return interviewSlotId == nil ? "면접일이 확정되지 않음" : "면접일 확정"
    case .reviewWaiting:
      return "면접을 완료함"
    case .reviewCompleted:
      return isPassed == true ? "합격" : "불합격"
    default :
      return ""
    }
  }
  
  var statusIcon: String {
    let status = ApplicationStatus(rawValue: self.status)
    
    switch status {
    case .submitted:
      return "doc.text.fill"
    case .interviewWaiting:
      return interviewSlotId == nil ? "clock.fill" : "checkmark.circle.fill"
    case .reviewWaiting:
      return "eye.fill"
    case .reviewCompleted:
      return isPassed == true ? "checkmark.circle.fill" : "xmark.circle.fill"
    default :
      return ""
    }
  }
  
  var statusColor: Color {
    let status = ApplicationStatus(rawValue: self.status)
    
    switch status {
    case .submitted:
      return .blue
    case .interviewWaiting:
      return interviewSlotId == nil ? .gray : .green
    case .reviewWaiting:
      return .yellow
    case .reviewCompleted:
      return isPassed == true ? .green : .red
    default :
      return .black
    }
  }
}
