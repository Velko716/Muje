//
//  PostListItem.swift
//  Muje
//
//  Created by 김서현 on 8/7/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PostListItem: View {
    let post: Post
    let thumbnailImage: PostImage?
    let cachedURL: String?
    
    var body: some View {
        HStack {
            // MARK: 상단 - 동아리명
            VStack(alignment: .leading, spacing: 0) {
                Text(post.organization)
                    .caption14Medium()
                    .foregroundStyle(.gray500)
                
                // MARK: 중간 - 제목
                Text(post.title)
                    .body2SemiBold16()
                    .foregroundStyle(.gray700)
                    .lineLimit(2)
                Spacer().frame(height: 12)
                // MARK: 하단 - 모집 상태
                Text(post.status)
                    .caption14Regular()
                    .foregroundStyle(.gray400)
            } //: VSTACK
            .padding(.vertical, 20)
            Spacer(minLength: 16)
            // MARK: 우측 - 사진 (썸네일)
          if let thumbnailImage = thumbnailImage {
            ThumbnailAsyncImage(
              postImage: thumbnailImage,
              cachedURL: cachedURL
            )
            .id(thumbnailImage.imageId)
          }
        } //: HSTACK
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
    }
}

#Preview {
  PostListItem(
    post: Post(
      postId: UUID(),
      authorUserId: "",
      title: "",
      organization: "",
      content: "",
      recruitmentStart: Timestamp(date: Date()),
      recruitmentEnd: Timestamp(date: Date()),
      status: PostStatus.recruiting.rawValue,
      authorName: "",
      authorOrganization: ""
    ),
    thumbnailImage: PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    ), cachedURL: ""
  )
}
