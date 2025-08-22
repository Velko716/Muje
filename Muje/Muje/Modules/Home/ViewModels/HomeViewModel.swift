//
//  HomeViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation
import Firebase
import FirebaseStorage


@Observable
final class HomeViewModel {
    var postList: [Post] = []
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var thumbnailImages: [UUID: UIImage] = [:] //postId를 키로 하는 딕셔너리
    var postIds: [UUID] = []
    init() {
        postListFetch()
    }
    
    func postListFetch() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                
                postList = try await
                FirestoreManager.shared.fetchPosts(
                    as: Post.self,
                    .posts,
                    order: "created_at",
                    descending: true, //최신순 정렬
                    count: 0 //count가 0이면 모든 데이터를 가져옴
                )
                
                postIds = postList.map { $0.postId } //모든 post들의 postID 추출해서 썸네일 이미지 가져올 때 뽑아서 가져옴
                let postImages = try await FirestoreManager.shared.fetchThumbnailImages(for: postIds)
                
                thumbnailImages = await FirestoreManager.shared.fetchThumbnailUIImages(from: postImages)
                
                isLoading = false

                
            }  catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }

    
}
