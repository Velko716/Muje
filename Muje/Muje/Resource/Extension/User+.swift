//
//  User+.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import Foundation

extension User {
  var genderEnum: Gender? {
    return Gender(rawValue: self.gender)
  }
  
  var genderDisplay: String {
    return genderEnum?.displayName ?? "-"
  }
  
  var age: Int {
    Calendar.current.component(.year, from: Date()) - birthYear + 1
  }
  
  var ageString: String {
    "\(age)세"
  }
}
