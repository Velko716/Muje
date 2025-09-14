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
  @Bindable var viewModel: RecruitmentViewModel
  
  let postImage: [PostImage]
  //  let cachedURL: [UUID: String]
  
  
  var sortedImageUrls: [PostImage] {
    postImage.sorted{ $0.imageOrder < $1.imageOrder }
  }
  
  var body: some View {
    GeometryReader { geometry in
      let minY = geometry.frame(in: .global).minY
      let size = geometry.size
      let screenWidth = UIScreen.main.bounds.width
      
      ZStack {
        TabView(selection: $currentPage) {
          ForEach(sortedImageUrls.indices, id: \.self) { index in
            let image = sortedImageUrls[index]
            DownloadImage(postImage: image, cachedURL: viewModel.imageURLCache[image.imageId])
              .frame(width: screenWidth)
              .clipped()
              .highPriorityGesture(
                TapGesture().onEnded {
                  selectedImageForViewr = SelectedImageIndex(index: index)
                }
              )
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
        
        VStack {
          LinearGradient(
            gradient: Gradient(colors: [
              Color.black.opacity(0.7),
              Color.black.opacity(0.5),
              Color.clear
            ]),
            startPoint: .top,
            endPoint: .bottom
          )
          .frame(
            height: (size.height + (
              minY > 0 ? minY : 0
            )) / 3
          )
          .offset(y: minY > 0 ? -minY : 0)
          Spacer()
        }
        .allowsHitTesting(false)
        
        VStack {
          Spacer()
          HStack {
            Spacer()
            ImageIndicator
          }
          .padding(.bottom, 16)
          .padding(.trailing, 16)
        }
      }
    }
    .frame(height: UIScreen.main.bounds.width)
    .fullScreenCover(item: $selectedImageForViewr) { selectedImage in
      ImageDetail(
        selectedIndex: selectedImage.index,
        onDismiss: { selectedImageForViewr = nil },
        postImage: sortedImageUrls,
        cachedURL: viewModel.imageURLCache
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
      if let urlString = downloadURL, let url = URL(string: urlString) {
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
    .onChange(of: cachedURL) { _, newValue in
      if let newValue {
        self.downloadURL = newValue
        self.isLoading = false
      }
    }
    .task(id: postImage.imageId) {
      if let cachedURL = cachedURL {
        downloadURL = cachedURL
        isLoading = false
        return
      }
      
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
}

struct SelectedImageIndex: Identifiable {
  let id = UUID()
  let index: Int
}

#Preview {
  ImageView(
    viewModel: RecruitmentViewModel(), postImage: [PostImage(
      imageId: UUID(),
      postId: "",
      imageUrl: "",
      imageOrder: 0
    )]
  )
}
