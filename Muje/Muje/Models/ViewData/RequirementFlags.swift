//
//  RequirementFlags.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import Foundation

struct RequirementFlags: Equatable, Hashable {
  let requiresName: Bool = true
  let requiresStudentId: Bool
  let requiresDepartment: Bool
  let requiresGender: Bool
  let requiresAge: Bool
  let requiresPhone: Bool
  
  init(from post: Post) {
    self.requiresStudentId = post.requiresStudentId
    self.requiresDepartment = post.requiresDepartment
    self.requiresGender = post.requiresGender
    self.requiresAge = post.requiresAge
    self.requiresPhone = post.requiresPhone
  }
}
