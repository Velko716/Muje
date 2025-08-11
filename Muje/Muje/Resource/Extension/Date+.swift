//
//  Date.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import Foundation

extension Date {
  var shortDateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 d일"
    
    return formatter.string(from: self)
  }
  
  var fullDateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 M월 d일"
    
    return formatter.string(from: self)
  }
}
