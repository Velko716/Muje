//
//  ImageDetailView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

extension ImageView {
  var ImageDetailView: some View {
    ZStack {
      Color.black
        .edgesIgnoringSafeArea(.all)
      
      TabView(selection: $selectedImageIndex) {
        ForEach(Array(sortedImageUrls.enumerated()), id: \.offset) { index, imageURL in
          AsyncImage(url: URL(string: imageURL)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
              .tint(.white)
          }
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
      ForEach(0..<sortedImageUrls.count, id: \.self) { index in
        Circle()
          .fill(
            index == selectedImageIndex ? .white : .white.opacity(0.5)
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
