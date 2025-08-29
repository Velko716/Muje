//
//  PostSuggestion.swift
//  Muje
//
//  Created by 조재훈 on 8/28/25.
//

import Foundation

struct PostSuggestion: Codable, Identifiable {
  let postId: String
  let title: String
  let organization: String
  
  var id: String { postId }
}
