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
                    count: 10
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
    
    //MARK: 목 데이터 사용
    static let mockPosts: [Post] = [
        Post(postId: UUID(), authorUserId: "temp", title: "💃공과대학 댄스동아리 D.I.US 11기 신입부원 모집💃", organization: "세오의동아리", content: "내용입니다.", recruitmentStart: Timestamp(date: Date()), recruitmentEnd: Timestamp(date: Date()), hasInterview: true, status: "모집중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "temp", authorOrganization: "세오의 동아리", createdAt: Timestamp(date: Date()), updatedAt: Timestamp(date: Date())),
        Post(postId: UUID(), authorUserId: "temp", title: "💃공과대학 댄스동아리 D.I.US 11기 신입부원 모집💃", organization: "세오의동아리", content: "내용입니다.", recruitmentStart: Timestamp(date: Date()), recruitmentEnd: Timestamp(date: Date()), hasInterview: true, status: "모집중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "temp", authorOrganization: "세오의 동아리", createdAt: Timestamp(date: Date()), updatedAt: Timestamp(date: Date()))
    ]
    
}
