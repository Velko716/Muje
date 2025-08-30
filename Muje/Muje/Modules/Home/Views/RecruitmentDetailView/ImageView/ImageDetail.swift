//
//  ImageDetail.swift
//  Muje
//
//  Created by 조재훈 on 8/25/25.
//

import SwiftUI

struct ImageDetail: View {
  @State private var selectedIndex: Int
  @State private var imageURLs: [UUID: String] = [:]
  
  let onDismiss: () -> Void
  let postImage: [PostImage]
  let cachedURL: [UUID: String]
  
  init(selectedIndex: Int, onDismiss: @escaping () -> Void, postImage: [PostImage], cachedURL: [UUID: String]) {
    self._selectedIndex = State(initialValue: selectedIndex)
    self.onDismiss = onDismiss
    self.postImage = postImage
    self.cachedURL = cachedURL
  }
  
  var body: some View {
    ZStack {
      Color.black
        .edgesIgnoringSafeArea(.all)
      
      TabView(selection: $selectedIndex) {
        ForEach(postImage.indices, id: \.self) { index in
          ImageDetailItem(
            postImage: postImage[index],
            cachedURL: imageURLs[postImage[index].imageId]
          )
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .background(Color.black)
            .tag(index)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .scrollIndicators(.hidden)
      
      VStack {
        Spacer()
        DetailIndicator
      }
      .padding(.leading, 16)
      
      BackButton
    }
    .gesture(
      DragGesture()
        .onEnded { value in
          if value.translation.height > 100 && abs(value.translation.width) < abs(value.translation.height) {
            onDismiss()
          }
        }
    )
    .task {
      await loadAllImages()
    }
  }
  
  private var DetailIndicator: some View {
    HStack(spacing: 8) {
      ForEach(0..<postImage.count, id: \.self) { index in
        Circle()
          .fill(
            index == selectedIndex ? .white : .white.opacity(0.5)
          )
          .frame(width: 8, height: 8)
      }
    }
    .padding(.leading, -16)
  }
  
  private var BackButton: some View {
    VStack {
      HStack {
        Button {
          onDismiss()
        } label: {
          Image(systemName: "xmark")
        }
        Spacer()
      }
      Spacer()
    }
    .padding(.leading, 16)
    .padding(.top, 16)
  }
  
  private func loadAllImages() async {
    await withTaskGroup(of: (UUID, String?).self) { group in
      for image in postImage {
        group.addTask {
          if let cached = cachedURL[image.imageId] {
            return (image.imageId, cached)
          }
          
          do {
            let url = try await image.getDownloadURL()
            return (image.imageId, url)
          } catch {
            print("독립 이미지 로드 실패")
            return (image.imageId, nil)
          }
        }
      }
      for await (imageId, url) in group {
        if let url = url {
          await MainActor.run {
            imageURLs[imageId] = url
          }
        }
      }
    }
  }
}


struct ImageDetailItem: View {
  let postImage: PostImage
  let cachedURL: String?
  
  var body: some View {
    Group {
      if let urlString = cachedURL, let url = URL(string: urlString) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          ProgressView()
        }
      } else {
        ProgressView()
      }
    }
  }
}

#Preview {
  ImageDetail(
    selectedIndex: 0,
    onDismiss: {
    },
    postImage: [PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    )],
    cachedURL: [:]
  )
}
