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
                FirestoreManager.shared.fetch(
                    as: Post.self,
                    .posts,
                    order: "createdAt"
                )
                postList = fetchPosts
                isLoading = false
                
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
                
                print("❌ HomeViewModel - postListFetch() error: \(error)")
            }
        }
    }
    
    //MARK: 목 데이터 사용
    static var mock: HomeViewModel {
        let vm = HomeViewModel()
        vm.postList = [
            Post(postId: UUID(), authorUserId: "temp", title: "동아리 모집합니다", organization: "세오의동아리", content: "내용입니다.", recruitmentStart: Timestamp(date: Date()), recruitmentEnd: Timestamp(date: Date()), hasInterview: true, status: "모집중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "temp", authorOrganization: "세오의 동아리", createdAt: Timestamp(date: Date()), updatedAt: Timestamp(date: Date()))
        ]
        return vm
    }
}
