//
//  PostListItem.swift
//  Muje
//
//  Created by 김서현 on 8/7/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PostListItem: View {
    let post: Post
    let thumbnailImage: PostImage?
    
    var body: some View {
        HStack {
            // MARK: 상단 - 동아리명
            VStack(alignment: .leading, spacing: 0) {
                Text(post.organization)
                    .caption14Medium()
                    .foregroundStyle(.gray500)
                
                // MARK: 중간 - 제목
                Text(post.title)
                    .body2_16SemiBold()
                    .foregroundStyle(.gray700)
                    .lineLimit(2)
                Spacer().frame(height: 12)
                // MARK: 하단 - 모집 상태
                Text(post.status)
                    .caption14Regular()
                    .foregroundStyle(.gray400)
            } //: VSTACK
            .padding(.vertical, 20)
            Spacer(minLength: 16)
            // MARK: 우측 - 사진 (썸네일)
            ThumbnailAsyncImage(postImage: thumbnailImage)
        } //: HSTACK
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
    }
}

struct ThumbnailAsyncImage: View {
    let postImage: PostImage?
    @State private var downloadURL: String?
    @State private var isLoading: Bool = true
    
    var body: some View {
        Group {
            if let downloadURL = downloadURL {
                AsyncImage(url: URL(string: downloadURL)) { image in
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
                defaultImageView
            }
        }
        .frame(width: 78, height: 78)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: postImage?.imageId) {
            await loadDownloadURL()
        }
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
        guard let postImage = postImage else {
            await MainActor.run { self.isLoading = false }
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
