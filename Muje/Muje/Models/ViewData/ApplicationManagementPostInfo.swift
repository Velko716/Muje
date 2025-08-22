//
//  ApplicationManagementPostInfo.swift
//  Muje
//
//  Created by 조재훈 on 8/11/25.
//

import Foundation
import FirebaseFirestore

struct ApplicationManagementPostInfo: Equatable, Hashable {
  let title: String
  let organization: String
  let recruitmentStart: Timestamp
  let recruitmentEnd: Timestamp
  let status: String
  let hasInterview: Bool
  
  init(from post: Post) {
    self.title = post.title
    self.organization = post.organization
    self.recruitmentStart = post.recruitmentStart
    self.recruitmentEnd = post.recruitmentEnd
    self.status = post.status
    self.hasInterview = post.hasInterview
  }
}
