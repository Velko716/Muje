//
//  ImageView.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI

struct ImageView: View {
  @State var currentPage: Int = 0
//  @State var selectedImageIndex: Int
//  @State var showImageViewer: Bool = false
  @State private var selectedImageForViewr: SelectedImageIndex? = nil
  
  let postImage: [PostImage]
  let cachedURL: [UUID: String]
  
  var sortedImageUrls: [PostImage] {
    postImage.sorted{ $0.imageOrder < $1.imageOrder }
  }
  
  var body: some View {
    GeometryReader { geometry in
      let minY = geometry.frame(in: .global).minY
      let size = geometry.size
      let screenWidth = UIScreen.main.bounds.width
      
      TabView(selection: $currentPage) {
        ForEach(sortedImageUrls.indices, id: \.self) { index in
          let image = sortedImageUrls[index]
          DownloadImage(postImage: image, cachedURL: cachedURL[image.imageId])
          .frame(width: screenWidth)
          .clipped()
          .onTapGesture {
            selectedImageForViewr = SelectedImageIndex(index: index)
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
//    .fullScreenCover(isPresented: $showImageViewer) {
//      ImageDetail(
//        selectedIndex: $selectedImageIndex,
//        showImageViewer: $showImageViewer,
//        postImage: sortedImageUrls,
//        cachedURL: cachedURL
//      )
//    }
    .fullScreenCover(item: $selectedImageForViewr) { selectedImage in
      ImageDetail(
        selectedIndex: selectedImage.index,
        onDismiss: { selectedImageForViewr = nil },
        postImage: sortedImageUrls,
        cachedURL: cachedURL
      )
    }
    
  }
}

struct DownloadImage: View {
  let postImage: PostImage
  let cachedURL: String?
  
  @State private var downloadURL: String? = nil
  @State private var isLoading: Bool = true
  
  var body: some View {
    Group {
      if let urlString = cachedURL ?? downloadURL, let url = URL(string: urlString) {
        AsyncImage(url: url) { image in
            image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          ProgressView()
            .tint(.gray)
        }
      } else {
        Rectangle()
          .fill(Color.gray.opacity(0.3))
      }
    }
    .task(id: postImage.imageId) {
      if cachedURL == nil, let url = try? await postImage.getDownloadURL() {
        await MainActor.run {
          self.downloadURL = url
          self.isLoading = false
        }
      } else {
        isLoading = false
      }
    }
  }
}

struct SelectedImageIndex: Identifiable {
  let id = UUID()
  let index: Int
}

#Preview {
  ImageView(
    postImage: [PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    )],
    cachedURL: [:]
  )
}
