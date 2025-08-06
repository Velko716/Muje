//
//  ImageView.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI

struct ImageView: View {
  @State var currentPage: Int = 0
  @State var selectedImageIndex: Int? = nil
  @State var showImageViewer: Bool = false
  
  let postImage: [PostImage]
  
  var body: some View {
    GeometryReader { geometry in
      let minY = geometry.frame(in: .global).minY
      let size = geometry.size
      let screenWidth = UIScreen.main.bounds.width
      
      TabView(selection: $currentPage) {
        ForEach(Array(sortedImageUrls.enumerated()), id: \.offset) { index, imageURL in
          AsyncImage(url: URL(string: imageURL)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          } placeholder: {
            Rectangle()
              .fill(Color.gray.opacity(0.3))
              .overlay {
                ProgressView()
                  .tint(.gray)
              }
          }
          .frame(width: screenWidth)
          .clipped()
          .onTapGesture {
            selectedImageIndex = index
            showImageViewer = true
          }
          .tag(index)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .frame(
        width: screenWidth,
        height: size.height + (
          minY > 0 ? minY : 0
        )
      )
      .clipped()
      .offset(y: minY > 0 ? -minY : 0)
      
      ImageIndicator
      
    }
    .frame(height: UIScreen.main.bounds.width)
    .fullScreenCover(isPresented: $showImageViewer) {
      ImageDetailView
    }
  }
}

extension ImageView {
  var sortedImageUrls: [String] {
    postImage
      .sorted { $0.imageOrder < $1.imageOrder }
      .map { $0.imageUrl }
  }
}

#Preview {
  ImageView(
    postImage: [PostImage(
      imageId: UUID(),
      postId: "post_Id",
      imageUrl: "https://picsum.photos/280/200?random=1",
      imageOrder: 0
    )
    ]
  )
}
