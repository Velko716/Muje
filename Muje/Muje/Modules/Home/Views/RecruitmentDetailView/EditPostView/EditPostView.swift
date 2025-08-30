//
//  EditPostView.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct EditPostView: View {
  @Bindable var viewModel: EditPostViewModel
  
  var body: some View {
    ZStack {
        VStack(spacing: 32) {
          CustomTextField(
            title: "공고제목",
            tempTitle: "공고 제목을 적어주세요",
            textValue: $viewModel.title, maxLength: 100
          )
          CustomTextField(
            title: "단체명",
            tempTitle: "단체명을 적어주세요",
            textValue: $viewModel.organization, maxLength: 50
          )
          PickerView(
            title: "모집 마감일",
            content: viewModel.endDateString,
            function: {
              viewModel.isPicker = true
            })
          imageView
          contentView
        }
        .padding(.bottom, 100)
    }
  }
  
  // MARK: - 이미지 뷰
  private var imageView: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 4) {
        Text("사진")
        Text("최대 5장")
          .font(.caption)
          .foregroundStyle(Color.gray)
      }
      
      ScrollView(.horizontal) {
        HStack(spacing: 8) {
          // PhotosPicker
          photoPicker
          
          // 기존 이미지들 표시
          existImageView
          
          // 새 이미지들 표시
          selectedImageView

        }
        .animation(.spring(), value: viewModel.selectedImagesData)
      }
      .scrollIndicators(.hidden)
    }
    .onChange(of: viewModel.selectedItems) { old, new in
      Task {
        await viewModel.loadSelectedImages(newItems: new)
      }
    }
  }
  
  private var photoPicker: some View {
    PhotosPicker(
      selection: $viewModel.selectedItems,
      maxSelectionCount: max(1, 5 - viewModel.existingImages.count), // 기존 이미지
      selectionBehavior: .ordered,
      matching: .images
    ) {
      ZStack {
        VStack(spacing: 2) {
          Image(systemName: "photo.fill.on.rectangle.fill")
          Text("\(viewModel.totalImageCount)/5")  // 전체 개수 표시
        }
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.gray.opacity(0.2))
          .frame(width: 84, height: 84)
      }
      .foregroundStyle(Color.gray)
    }
  }
  // MARK: - Firestorage에서 불러온 이미지
  private var existImageView: some View {
    ForEach(viewModel.existingImages.indices, id: \.self) { index in
      let postImage = viewModel.existingImages[index]
      ExistingImageCard(
        postImage: postImage,
        onDelete: { viewModel.removeExistingImage(at: index) },
        cachedURL: (viewModel.imageURLCache[postImage.imageId]) ?? ""
      )
//            ExistingImageCard(postImage: postImage) {
//              viewModel.removeExistingImage(at: index)
//            }
    }
  }
  // MARK: - PhotosPicker에서 선택된 이미지
  private var selectedImageView: some View {
    ForEach(viewModel.selectedImagesData.indices, id: \.self) { index in
      let imageData = viewModel.selectedImagesData[index]
      if let uiImage = UIImage(data: imageData) {
        ZStack(alignment: .topTrailing) {
          Image(uiImage: uiImage)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 84, height: 84)
            .scaledToFill()
          
          Button(action: {
            viewModel.removeNewImage(at: index)
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(Color.gray)
              .padding(5)
          }
        }
      }
    }
  }
  
  private var contentView: some View {
    VStack(alignment: .leading) {
      Text("모집 내용")
      TextField("활동 목적, 모집 인원, 활동 일정, 지원 자격 등을 자유롭게 작성해주세요", text: $viewModel.content, axis: .vertical)
        .maxLength(text: $viewModel.content, 2000)
        .lineLimit(2...)
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
  

  

}

// MARK: - 기존 이미지 카드 (getDownloadURL 사용)
struct ExistingImageCard: View {
  let postImage: PostImage
  let onDelete: () -> Void
  let cachedURL: String
  
  @State private var downloadURL: String?
  @State private var isLoading = true
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Group {
        if cachedURL != "" {
          AsyncImage(url: URL(string: cachedURL)) { image in
            image
              .resizable()
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .scaledToFill()
          } placeholder: {
            ProgressView()
          }
        } else if isLoading {
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 84, height: 84)
            .overlay(
              ProgressView().scaleEffect(0.8)
              )
        } else {
          if let downloadURL = downloadURL {
            AsyncImage(url: URL(string: downloadURL)) { image in
              image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scaledToFill()
            } placeholder: {
              ProgressView()
            }
          }
        }
      }
      .frame(width: 84, height: 84)
      
      Button(action: onDelete) {
        Image(systemName: "xmark.circle.fill")
          .foregroundStyle(Color.gray)
          .padding(5)
      }
    }
      .task(id: postImage.imageId) {
        await loadDownloadURL()
      }
    
  }
  
  private func loadDownloadURL() async {
    if cachedURL == "" {
      do {
        let url = try await postImage.getDownloadURL()
        await MainActor.run {
          withAnimation(.easeIn(duration: 0.2)) {
            self.downloadURL = url
            self.isLoading = false
          }
        }
      } catch {
        print("이미지 URL 로드 실패: \(error)")
        await MainActor.run {
          withAnimation(.easeInOut(duration: 0.2)) {
            self.isLoading = false
          }
        }
      }
    }
  }
}
