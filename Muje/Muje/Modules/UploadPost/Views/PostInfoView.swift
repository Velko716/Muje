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
    let config = Font.lineHeight(
        type: .medium,
        fontSize: 16,
        lineHeightPercent: 1.85,
        letterSpacingPercent: -1
    )
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                CustomInput(title: "모집글 제목", tempTitle: "공고 제목을 적어주세요", textValue: $postInfoViewModel.title, maxLength: 100)
                CustomInput(title: "단체명", tempTitle: "단체명을 적어주세요", textValue: $postInfoViewModel.organization, maxLength: 50)
                
                PostDatePicker(title: "모집 마감일", content: postInfoViewModel.endDateString, function: {
                    postInfoViewModel.isPicker = true
                })
                
                imageView
                contentView
            }
            .padding(.bottom, 67)
        }
    }
    
    private var imageView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom,spacing: 8) {
                Text("사진")
                    .caption14SemiBold()
                    .foregroundStyle(.gray700)
                Text("최대 5장")
                    .caption14Regular()
                    .foregroundStyle(.gray500)
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    PhotosPicker(selection: $postInfoViewModel.selectedItems, maxSelectionCount: 5, selectionBehavior: .ordered, matching: .images) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray50)
                                .frame(width: 84, height: 84)
                            VStack(spacing: 2) {
                                Image(.imageUploadIcon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                HStack(spacing: 0) {
                                    if postInfoViewModel.selectedItems.count == 0 {
                                            Text("\(postInfoViewModel.selectedItems.count)")
                                                .caption12Regular()
                                                .foregroundStyle(.gray500)
                                        } else {
                                            Text("\(postInfoViewModel.selectedItems.count)")
                                                .caption12Bold()
                                                .foregroundStyle(.pointSkyBlue)
                                        }
                                    Text("/5")
                                        .caption12Regular()
                                        .foregroundStyle(.gray500)
                                }
                            }
                        }
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
                                    Image(.xmarkCircleFill)
                                })
                                .padding(.top, 4)
                                .padding(.trailing, 5)
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
                .caption14SemiBold()
            TextField("활동 목적, 모집 인원, 활동 일정, 지원 자격 등을 자유롭게 작성해주세요", text: $postInfoViewModel.content, axis: .vertical)
                .maxLength(text: $postInfoViewModel.content, 2000)
                .lineLimit(2...)
                .frame(minHeight: 168, alignment: .top)
                .font(.pretendard(type: .medium, size: 16))
                .padding(.vertical, config.verticalPadding)
                .tracking(config.letterSpacing)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .strokeBorder(.gray100, lineWidth: 1)
                )
        }
    }
}


#Preview {
    PostInfoView(postInfoViewModel: .init())
}
