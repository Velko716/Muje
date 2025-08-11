//
//  Gender+.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import Foundation

extension Gender {
  var displayName: String {
    switch self {
    case .male:
      return "남자"
    case .female:
      return "여자"
    }
  }
}
