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
  
  @MainActor var imageURLCache: [UUID: String] = [:]
  
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
      
      await preloadImageURL()
      
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
      
      await preloadImageURL()
      
      isLoadingMore = false
      
    } catch {
      print("추가 로딩 실패 \(error)")
      isLoadingMore = false
    }
  }
  
  @MainActor
  func preloadImageURL() async {
    await withTaskGroup(of: (UUID, String?).self) { group in
      for (postId, image) in thumbnailImages {
        if imageURLCache[postId] == nil {
          group.addTask {
            do {
              let url = try await image.getDownloadURL()
              return (postId, url)
            } catch {
              print("이미지 url 로드 실패")
              return (postId, nil)
            }
          }
        }
      }
      for await (postId, url) in group {
        if let url = url {
          imageURLCache[postId] = url
        }
      }
    }
  }
}
