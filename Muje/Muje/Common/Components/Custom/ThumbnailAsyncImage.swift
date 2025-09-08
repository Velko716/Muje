//
//  ThumbnailAsyncImage.swift
//  Muje
//
//  Created by 조재훈 on 9/5/25.
//

import SwiftUI

struct ThumbnailAsyncImage: View {
  let postImage: PostImage
  let cachedURL: String?
  
  var size: CGFloat = 78
  @State private var downloadURL: String? = nil
  @State private var isLoading: Bool = true
  
  private var effectiveURL: String? {
    return cachedURL ?? downloadURL
  }
  
  var body: some View {
    Group {
      if let urlString = effectiveURL,
          let url = URL(string: urlString) {
        AsyncImage(url: url) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } placeholder: {
          ProgressView()
        }
      } else if isLoading {
        ProgressView()
      } else {
        defaultImageView // FIXME: 앱로고?
      }
    }
    .frame(width: size, height: size)
    .clipped()
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .onAppear {
      if let cachedURL = cachedURL {
        downloadURL = cachedURL
        isLoading = false
      } else if downloadURL == nil {
        Task {
          await loadDownloadURL()
        }
      }
    }
//    .onChange(of: cachedURL) { oldValue, newValue in
//      if let newValue {
//        self.downloadURL = newValue
//        self.isLoading = false
//      }
//    }
//    .task(id: postImage.imageId) {
//      if let cachedURL = cachedURL {
//        downloadURL = cachedURL
//        isLoading = false
//        return
//      }
//      await loadDownloadURL()
//    }
  }
  
  private var defaultImageView: some View {
    Rectangle()
      .fill(Color.gray.opacity(0.3))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(
        Image(systemName: "photo")
          .font(.title3)
          .foregroundStyle(.gray)
      )
  }
  
  private func loadDownloadURL() async {
    do {
      let url = try await postImage.getDownloadURL()
      await MainActor.run {
        self.downloadURL = url
        self.isLoading = false
      }
    } catch {
      await MainActor.run {
        self.isLoading = false
      }
    }
  }
}
