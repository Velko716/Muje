//
//  PostBasicInfo.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import Foundation

struct PostBasicInfo: Equatable, Hashable {
  let title: String
  let organization: String
  let authorUserId: String
  
  init(from post: Post) {
    self.title = post.title
    self.organization = post.organization
    self.authorUserId = post.authorUserId
  }
}
