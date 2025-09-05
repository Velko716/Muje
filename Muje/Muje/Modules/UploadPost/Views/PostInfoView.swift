//
//  PostInfoView.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI
import PhotosUI

struct PostInfoView: View {
    @Bindable var postInfoViewModel: PostInfoViewModel
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                CustomInput(title: "공고제목", tempTitle: "공고 제목을 적어주세요", textValue: $postInfoViewModel.title, maxLength: 100)
                CustomInput(title: "단체명", tempTitle: "단체명을 적어주세요", textValue: $postInfoViewModel.organization, maxLength: 50)
                
                PostDatePicker(title: "모집 마감일", content: postInfoViewModel.endDateString, function: {
                    postInfoViewModel.isPicker = true
                })
                
                imageView
                contentView
            }
            .padding(.bottom, 160)
        }
    }
    
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
                    PhotosPicker(selection: $postInfoViewModel.selectedItems, maxSelectionCount: 5, selectionBehavior: .ordered, matching: .images) {
                        ZStack {
                            VStack(spacing: 2) {
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                Text("\(postInfoViewModel.selectedItems.count)/5")
                            }
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 84, height: 84)
                        }
                        .foregroundStyle(Color.gray)
                    }
                    
                    ForEach(postInfoViewModel.selectedImagesData.indices, id: \.self) { index in
                        let imageData = postInfoViewModel.selectedImagesData[index]
                        if let uiImage = UIImage(data: imageData) {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 84, height: 84)
                                    .scaledToFill()
                                
                                Button(action: {
                                    postInfoViewModel.removeImage(at: index)
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Color.gray)
                                        .padding(5)
                                })
                            }
                        }
                    }
                }
                .animation(.spring(), value: postInfoViewModel.selectedImagesData)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            Text("모집 내용")
            TextField("활동 목적, 모집 인원, 활동 일정, 지원 자격 등을 자유롭게 작성해주세요", text: $postInfoViewModel.content, axis: .vertical)
                .maxLength(text: $postInfoViewModel.content, 2000)
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


#Preview {
    PostInfoView(postInfoViewModel: .init())
}
