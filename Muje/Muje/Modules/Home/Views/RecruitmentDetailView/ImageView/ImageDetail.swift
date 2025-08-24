//
//  ImageDetail.swift
//  Muje
//
//  Created by 조재훈 on 8/25/25.
//

import SwiftUI

struct ImageDetail: View {
  @Binding var selectedIndex: Int
  @Binding var showImageViewer: Bool
  let postImage: [PostImage]
  let cachedURL: [UUID: String]
  
  var body: some View {
    ZStack {
      Color.black
        .edgesIgnoringSafeArea(.all)
      
      TabView(selection: $selectedIndex) {
        ForEach(postImage.indices, id: \.self) { index in
          DownloadImage(
            postImage: postImage[index],
            cachedURL: cachedURL[postImage[index].imageId]
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
            showImageViewer = false
          }
        }
    )
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
          showImageViewer = false
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
}

#Preview {
  ImageDetail(
    selectedIndex: .constant(0), showImageViewer: .constant(true),
    postImage: [PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    )], cachedURL: [:]
  )
}
