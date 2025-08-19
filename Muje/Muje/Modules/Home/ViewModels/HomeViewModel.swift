//
//  HomeViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation
import Firebase


@Observable
final class HomeViewModel {
    var postList: [Post] = []
    var errorMessage: String? = nil
    var isLoading: Bool = false
    
    init() {
        postListFetch()
    }
    
    func postListFetch() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                
                let fetchPosts = try await
                FirestoreManager.shared.fetchPosts(
                    as: Post.self,
                    .posts,
                    order: "createdAt",
                    descending: true, //최신순 정렬
                    count: 0 //count가 0이면 모든 데이터를 가져옴
                )
                postList = sortPostsByLatest(fetchPosts)

                isLoading = false
                
            }  catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    // FirestoreManager의 fetchPosts()에서 데이터 가져올 때 정렬을 먹이니까 자꾸 오류가 나서 그냥 다 갖고오고 클라이언트 측에서 정렬하도록 함수를 추가했습니다
    private func sortPostsByLatest(_ posts: [Post]) -> [Post] {
        return posts.sorted { $0.createdAt!.seconds > $1.createdAt!.seconds }
    }
    
}
