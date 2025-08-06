//
//  RecruitmentViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import Foundation

@Observable
final class RecruitmentViewModel {
  static let shared = RecruitmentViewModel()
  private init() {}
  private let firestoreManager = FirestoreManager.shared
  
  var postImages: [PostImage] = []
  var isLoading: Bool = false
  var errorMessage: String?
  var showError: Bool = false
  
  func loadPostImage(for postId: String) async {
    isLoading = true
    errorMessage = nil
    
    do {
      let images = try await fetchPostImage(postId: postId)
      
      self.postImages = images
      
    } catch {
      self.errorMessage = error.localizedDescription
      self.showError = true
      print("공고 이미지 로드 실패")
    }
    isLoading = false
  }
}

private extension RecruitmentViewModel {
  func fetchPostImage(postId: String) async throws -> [PostImage] {
    let db = firestoreManager.db
    
    let snapshot = try await db.collection(CollectionType.postImages.rawValue)
      .whereField("post_id", isEqualTo: postId)
      .order(by: "image_order")
      .getDocuments()
    
    let images = snapshot.documents.compactMap { document in
      do {
        return try document.data(as: PostImage.self)
      } catch {
        print("공고 이미지 디코딩 실패")
        return nil
      }
    }
    return images
  }
}
