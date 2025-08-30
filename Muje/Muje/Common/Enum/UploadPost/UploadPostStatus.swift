//
//  PostStatus.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import Foundation

enum UploadPostStatus: CaseIterable {
    case input
    case interview
    case info
    
    var postingLevel: String {
        switch self {
        case .input:
            return "1"
        case .interview:
            return "2"
        case .info:
            return "3"
        }
    }
    
    var postingTitle: String {
        switch self {
        case .input:
            return "모임 상세내용을 입력해주세요"
        case .interview:
            return "면접을 진행하시나요?"
        case .info:
            return "지원자로부터 \n수집할 정보를 선택해주세요"
        }
    }
  
    var padding: CGFloat {
      switch self {
      case .input:
          return 42
      case .interview:
          return 28
      case .info:
          return 16
      }
    }
}
