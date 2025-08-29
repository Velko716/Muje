//
//  Application.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import Foundation

extension Application: Identifiable {
  var id: UUID { applicationId }
  var genderEnum: Gender? {
    guard let applicantGender else { return nil }
    return Gender(rawValue: applicantGender)
  }
  
  var genderDisplay: String {
    genderEnum?.displayName ?? ""
  }
  
  var age: Int {
    guard let applicantBirthYear else { return 0 }
    return Calendar.current.component(.year, from: Date()) - applicantBirthYear + 1
  }
  
  var ageString: String {
    "\(age)세"
  }
}
