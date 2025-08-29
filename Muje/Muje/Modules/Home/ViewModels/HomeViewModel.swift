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
  
  private let firestoreManager = FirestoreManager.shared
  
  var postList: [Post] = []
  var isLoading: Bool = false
  var thumbnailImages: [UUID: PostImage] = [:] // postId를 키로 하는 딕셔너리
  
  
  //MARK: 페이징관련
  private let pageSize = 20
  private var lastDocument: DocumentSnapshot?
  
  var hasMoreData: Bool = true
  var isLoadingMore: Bool = false
  
  // MARK: - 페이징 관련 로직
  
  @MainActor
  func loadInitialPosts() async {
    guard !isLoading else { return }
    
    do {
      isLoading = true
      
      let (posts, thumbnails, lastDoc) = try await firestoreManager.fetchPostPaginated(
        limit: pageSize,
        lastDocument: nil
      )
      
      self.postList = posts
      self.thumbnailImages = thumbnails
      self.lastDocument = lastDoc
      self.hasMoreData = posts.count == pageSize
      
      isLoading = false
      
    } catch {
      print("초기로딩실패")
      isLoading = false
    }
  }
  
  @MainActor
  func loadMorePosts() async {
    guard !isLoadingMore && hasMoreData && lastDocument != nil else { return }
    
    do {
      isLoadingMore = true
      
      let (newPosts, newThumbnails, newLastDoc) = try await firestoreManager.fetchPostPaginated(
        limit: pageSize,
        lastDocument: lastDocument
      )
      
      self.postList.append(contentsOf: newPosts)
      self.thumbnailImages.merge(newThumbnails) { _, new in new }
      self.lastDocument = newLastDoc
      self.hasMoreData = newPosts.count == pageSize
      
      isLoadingMore = false
      
    } catch {
      print("추가 로딩 실패 \(error)")
      isLoadingMore = false
    }
  }
}
