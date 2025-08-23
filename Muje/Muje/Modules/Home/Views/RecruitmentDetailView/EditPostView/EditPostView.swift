//
//  InputView.swift
//  tempDos
//
//  Created by Air on 8/11/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct EditPostView: View {
  @State private var viewModel: EditViewModel
  
  init(post: Post, postImages: [PostImage]) {
    self._viewModel = State(initialValue: EditViewModel(post: post, postImages: postImages))
  }
  
  var body: some View {
    ZStack {
      ScrollView {
        VStack(spacing: 32) {
          CustomTextField(
            title: "공고제목",
            tempTitle: "공고 제목을 적어주세요",
            textValue: $viewModel.title
          )
          CustomTextField(
            title: "단체명",
            tempTitle: "단체명을 적어주세요",
            textValue: $viewModel.organization
          )
          PickerView(
            title: "모집 마감일",
            content: viewModel.endDate.endDateString,
            function: {
              viewModel.isPicker = true
            })
          imageView
          contentView
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 100)
      }
      bottomButton
      //      .padding(.bottom, 160)
      if viewModel.isPicker {
        dateView
      }
    }
  }
  
  // EditPostView.swift의 imageView 부분만 수정

  private var imageView: some View {
    VStack(alignment: .leading) {
      imageHeader
      imageScrollView
    }
    .onChange(of: viewModel.selectedPhotos) { _, newItems in
      Task {
        await viewModel.loadNewImages(with: newItems)
      }
    }
  }

  private var imageScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        // 이미지 추가 버튼
        if viewModel.totalImageCount < 5 {
          PhotosPicker(
            selection: $viewModel.selectedPhotos,
            maxSelectionCount: max(1, 5 - viewModel.totalImageCount),
            selectionBehavior: .ordered,
            matching: .images
          ) {
            ZStack {
              VStack(spacing: 2) {
                Image(systemName: "photo.fill.on.rectangle.fill")
                Text("\(viewModel.totalImageCount)/5")
              }
              RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 84, height: 84)
            }
            .foregroundStyle(Color.gray)
          }
        }
        
        // 기존 이미지들 표시
        ForEach(viewModel.existingImages.indices, id: \.self) { index in
          let postImage = viewModel.existingImages[index]
          ExistImageCard(
            postImage: postImage) {
              viewModel.removeExistingImage(at: index)
            }
        }
        
        // 새로 선택한 이미지들 표시 (팀원과 똑같은 방식!)
        ForEach(viewModel.newImagesData.indices, id: \.self) { index in
          let imageData = viewModel.newImagesData[index]
          if let uiImage = UIImage(data: imageData) {
            ZStack(alignment: .topTrailing) {
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 8))
              
              Button(action: {
                viewModel.removeNewImage(at: index)  // 팀원과 똑같은 방식!
              }) {
                Image(systemName: "xmark.circle.fill")
                  .foregroundStyle(Color.gray)
                  .padding(5)
              }
            }
          }
        }
      }
      .animation(.spring(), value: viewModel.newImagesData)
    }
    .scrollIndicators(.hidden)
  }
  
  
  
  
  
//  private var imageView: some View {
//    VStack(alignment: .leading) {
//      imageHeader
//      imageScrollView
//    }
//    .onChange(of: viewModel.selectedPhotos) { _, newItems in
//      Task {
//        await viewModel.loadAllImages(with: newItems)
//      }
//    }
//  }
  
  private var imageHeader: some View {
    HStack(spacing: 4) {
      Text("사진")
      Text("최대 5장")
        .font(.caption)
        .foregroundStyle(Color.gray)
    }
  }
  
//  private var imageScrollView: some View {
//    ScrollView(.horizontal, showsIndicators: false) {
//      HStack(spacing: 8) {
//        addImageButton
//        
//        ForEach(Array(viewModel.allImages.enumerated()), id: \.element.id) { index, imageItem in
//          ImageCardView(imageItem: imageItem) {
//            viewModel.removeImage(at: index)  // 정확한 인덱스로 삭제
//          }
//        }
//      }
//      .animation(.spring(), value: viewModel.selectedPhotos)
//    }
//    .scrollIndicators(.hidden)
//  }
  
//  private var existingImagesView: some View {
//    ForEach(Array(viewModel.currentImages.enumerated()), id: \.offset) { index, image in
//      ExistImageCard(postImage: image) {
//        viewModel.removeCurrentImage(at: index)
//      }
//    }
//  }
  
//  private var newImagesView: some View {
//    ForEach(Array(viewModel.newImageData.enumerated()), id: \.offset) { index, data in
//      NewImageCard(imageData: data) {
//        viewModel.removeNewImage(at: index)
//      }
//    }
//  }
  
  @ViewBuilder
//  private var addImageButton: some View {
//    if viewModel.allImages.count < 5 {
//      PhotosPicker(
//        selection: $viewModel.selectedPhotos,
//        maxSelectionCount: 5,
//        selectionBehavior: .ordered,
//        matching: .images
//      ) {
//        ZStack {
//          VStack(spacing: 2) {
//            Image(systemName: "photo.fill.on.rectangle.fill")
//            Text("\(viewModel.allImages.count)/5")
//          }
//          RoundedRectangle(cornerRadius: 10)
//            .fill(Color.gray.opacity(0.2))
//            .frame(width: 84, height: 84)
//        }
//        .foregroundStyle(Color.gray)
//     }
//    }
//  }
  
  private var contentView: some View {
    VStack(alignment: .leading) {
      Text("모집 내용")
      TextField("활동 목적, 모집 인원, 활동 일정, 지원 자격 등을 자유롭게 작성해주세요", text: $viewModel.content, axis: .vertical)
        .frame(minHeight: 168, alignment: .top)
        .bold()
        .padding(18)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.clear)
            .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
  }
  
  
  
  private var dateView: some View {
    ZStack {
      Rectangle()
        .fill(Color.black.opacity(0.4))
        .ignoresSafeArea()
        .onTapGesture {
          viewModel.isPicker = false
        }
      
      DatePicker("", selection: $viewModel.endDate, in: viewModel.dateRange, displayedComponents: .date)
        .background(content: {
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .offset(y: 12)
        })
        .datePickerStyle(.graphical)
        .onChange(of: viewModel.endDate, {
          viewModel.isPicker = false
          viewModel.endDateString = viewModel.endDate.shortDateString
        })
        .padding(.horizontal, 24)
    }
    .ignoresSafeArea()
  }
  
  private var bottomButton: some View {
    VStack {
      Spacer()
      Button {
        Task {
          await viewModel.updatedPost()
        }
      } label: {
        Text("수정 저장하기")
          .font(.system(size: 18))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .background(Color.black)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
  }
}

// MARK: - 기존 로드된 이미지 뷰
struct ExistImageCard: View {
  
  let postImage: PostImage
  let onDelete: () -> Void
  
  @State private var imageURL: String?
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      if let url = imageURL {
        AsyncImage(url: URL(string: url)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          RoundedRectangle(cornerRadius: 10)
            .fill(.gray.opacity(0.3))
            .overlay(
              ProgressView()
                .tint(.gray)
            )
        }
        .frame(width: 84, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
      Button(action: onDelete) {
        Image(systemName: "xmark.circle.fill")
          .foregroundStyle(Color.gray)
          .padding(5)
      }
    }
    .task {
      await loadImageURL()
    }
  }
  
  private func loadImageURL() async {
    if postImage.imageUrl.hasPrefix("http") {
      await MainActor.run {
        self.imageURL = postImage.imageUrl
      }
    } else {
      do {
        let url = try await postImage.getDownloadURL()
        await MainActor.run {
          self.imageURL = url
        }
      } catch {
        print("URL 변환 실패")
      }
    }
  }
}
// MARK: - 새로 선택한 이미지 뷰
//struct NewImageCard: View {
//  let imageData: Data
//  let onDelete: () -> Void
//  
//  var body: some View {
//    ZStack(alignment: .topTrailing) {
//      if let uiImage = UIImage(data: imageData) {
//        Image(uiImage: uiImage)
//          .resizable()
//          .aspectRatio(contentMode: .fill)
//          .frame(width: 84, height: 84)
//          .clipShape(RoundedRectangle(cornerRadius: 10))
//      }
//      Button(action: onDelete) {
//        Image(systemName: "xmark.circle.fill")
//          .foregroundStyle(Color.gray)
//          .padding(5)
//      }
//    }
//  }
//}
//
//struct ImageCardView: View {
//  let imageItem: ImageItem
//  let onDelete: () -> Void
//  
//  var body: some View {
//    ZStack(alignment: .topTrailing) {
//      Group {
//        switch imageItem.type {
//        case .existing(let postImage):
//          AsyncImage(url: URL(string: postImage.imageUrl)) { image in
//              image
//              .resizable()
//              .aspectRatio(contentMode: .fill)
//          } placeholder: {
//            ProgressView()
//          }
//        case .new(let data):
//          if let uiImage = UIImage(data: data) {
//            Image(uiImage: uiImage)
//              .resizable()
//              .aspectRatio(contentMode: .fill)
//          }
//        }
//      }
//      .frame(width: 84, height: 84)
//      .clipShape(RoundedRectangle(cornerRadius: 8))
//      
//      Button(action: onDelete) {
//        Image(systemName: "xmark.circle.fill")
//          .foregroundStyle(Color.gray)
//          .padding(5)
//      }
//    }
//  }
//}


#Preview {
  EditPostView(
    post: Post(
      postId: UUID(),
      authorUserId: "ddd",
      title: "ddd",
      organization: "ddd",
      content: "ddddddddddddddddd",
      recruitmentStart: Timestamp(date: Date()),
      recruitmentEnd: Timestamp(date: Date()),
      status: PostStatus.recruiting.rawValue,
      authorName: "dddddd",
      authorOrganization: "ddddd"
    ),
    postImages: [PostImage(
      imageId: UUID(),
      postId: "dd",
      imageUrl: "https://picsum.photos/280/200?random=1",
      imageOrder: 1
    )]
  )
}
