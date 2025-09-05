//
//  ThumbnailAsyncImage.swift
//  Muje
//
//  Created by 조재훈 on 9/5/25.
//

import SwiftUI

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
