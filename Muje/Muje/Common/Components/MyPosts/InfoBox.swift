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
    
    var body: some View {
        HStack(spacing: 8) {
          ThumbnailAsyncImage(
            postImage: thumbnailImage,
            size: 54
          )
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
    )
  )
}
