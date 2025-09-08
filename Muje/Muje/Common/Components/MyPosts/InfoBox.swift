//
//  InfoBox.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct InfoBox: View {
    var name: String
    var title: String
  
    let thumbnailImage: PostImage?
    let cachedURL: String?
    
    var body: some View {
        HStack(spacing: 8) {
          if let thumbnailImage = thumbnailImage {
            ThumbnailAsyncImage(
              postImage: thumbnailImage,
              cachedURL: cachedURL,
              size: 54
            )            
          }
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundStyle(Color.gray)
                Text(title)
                    .font(.title3)
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
        }
    }
}

#Preview {
  InfoBox(
    name: "동아리명",
    title: "댄스 동아리 OO 모집합니다",
    thumbnailImage: PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    ), cachedURL: ""
  )
}
