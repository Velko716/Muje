//
//  ImageType.swift
//  Muje
//
//  Created by 조재훈 on 8/21/25.
//

import Foundation

struct ImageItem: Identifiable {
  let id = UUID()
  let type: ItemType
  
  enum ItemType {
    case existing(PostImage)
    case new(Data)
  }
  
  static func existing(_ postImage: PostImage) -> ImageItem {
    return ImageItem(type: .existing(postImage))
  }
  
  static func new(_ date: Data) -> ImageItem {
    return ImageItem(type: .new(date))
  }
}
