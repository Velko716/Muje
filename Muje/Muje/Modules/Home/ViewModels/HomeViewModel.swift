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
    var postList: [Post] = [] {
        didSet {
            print("📝 postList 변경: \(oldValue.count) → \(postList.count)")
        }
    }
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
                FirestoreManager.shared.fetch(
                    as: Post.self,
                    .posts,
                    order: "createdAt",
                    count: 0 //count가 0이면 모든 데이터를 가져옴
                )
                postList = fetchPosts
                
                print("✅ 데이터 로드 성공: \(fetchPosts.count)개")
                print("🔍 첫 번째 게시글 제목: \(postList.first?.title ?? "없음")")
                
                isLoading = false
                
            }  catch {
                print("❌ HomeViewModel - postListFetch() error: \(error)")
                print("❌ 에러 타입: \(type(of: error))")
                print("❌ 에러 상세: \(error.localizedDescription)")
                
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
}
