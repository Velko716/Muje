//
//  ApplicationStatus.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation
import SwiftUI

enum ApplicationStatus: String, Codable, CaseIterable {
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
    
    func buttonString(slotId: String?) -> String {
        switch self {
        case .submitted:
            return "면접 제안 전"
        case .interviewWaiting:
            if slotId != nil {
                return "면접 일정 신청 완료"
            } else {
                return "면접일정 신청하기"
            }
        default:
            return "면접완료"
        }
    }
    
    var buttonStatus: Bool {
        switch self {
        case .interviewWaiting:
            return false
        default:
            return true
        }
    }
}

// MARK: - ManagementView 사용
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
  
  var statusIcon: Image {
    let status = ApplicationStatus(rawValue: self.status)
    
    switch status {
    case .submitted:
      return Image(.submit)
    case .interviewWaiting:
      return interviewSlotId == nil ? Image(.nonInterview) : Image(.interview)
    case .reviewWaiting:
      return Image(.interviewComplete)
    case .reviewCompleted:
      return isPassed == true ? Image(.pass) : Image(.nonPass)
    default :
      return Image(.iconStatusError)
    }
  }
  
  var statusColor: Color {
    let status = ApplicationStatus(rawValue: self.status)
    
    switch status {
    case .submitted:
      return .statusTextBlue
    case .interviewWaiting:
      return interviewSlotId == nil ? .statusTextOrange : .statusTextGreen
    case .reviewWaiting:
      return .gray500
    case .reviewCompleted:
      return isPassed == true ? .pointSkyBlue : .statusTextRed
    default :
      return .black
    }
  }
  
  func getInterviewDisplayText(with slot: InterviewSlot?) -> String {
    guard let slot = slot else {
      return "면접일이 확정되지 않음"
    }
    
    let dateString = slot.interviewDate.dateValue().shortDate
    let timeString = slot.interviewTime
    
    return "\(dateString) \(timeString) 면접일 확정"
  }
  
}
