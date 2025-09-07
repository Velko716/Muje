//
//  EditViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

@Observable
final class EditPostViewModel {
  private let firestoreManager = FirestoreManager.shared
  private let fireStorageManager = FireStorageManager.shared
  private let originalImages: [PostImage]
  private let originalPost: Post
  
  // MARK: - 공고 관련
  var title: String = ""
  var organization: String = ""
  var content: String = ""
  var startDate = Date()
  var endDate: Date = Date()
  var endDateString: String
  var isPicker: Bool = false
  var isLoading: Bool = false
  
  // MARK: - 이미지 관련
  var selectedItems: [PhotosPickerItem] = []        // PhotosPicker
  var selectedImagesData: [Data] = []               // 새 이미지 데이터
  var existingImages: [PostImage] = []              // 기존 이미지들
  
  // 전체 이미지 개수
  var totalImageCount: Int {
    existingImages.count + selectedImagesData.count
  }
  
  var dateRange: ClosedRange<Date> {
    let min = Date()
    let max = Date().addingTimeInterval(60 * 60 * 24 * 365)
    return min...max
  }
  
  @MainActor var imageURLCache: [UUID: String] = [:]
  
  init(post: Post, postImages: [PostImage]) {
    self.originalPost = post
    self.originalImages = postImages.sorted { $0.imageOrder < $1.imageOrder }
    self.existingImages = self.originalImages  // 기존 이미지들로 초기화
    
    self.title = post.title
    self.organization = post.organization
    self.content = post.content
    self.startDate = post.recruitmentStart.dateValue()
    self.endDate = post.recruitmentEnd.dateValue()
    self.endDateString = post.recruitmentEnd.dateValue().dateString
    
    Task { await preloadImageURL() }
  }
  
  @MainActor
  private func preloadImageURL() async {
    await withTaskGroup(of: (UUID, String?).self) { group in
      for image in existingImages {
        group.addTask {
          do {
            let url = try await image.getDownloadURL()
            return (image.imageId, url)
          } catch {
            print("이미지 url 로드 실패")
            return (image.imageId, nil)
          }
        }
      }
      for await (imageId, url) in group {
        if let url = url {
          imageURLCache[imageId] = url
        }
      }
    }
  }
  
  func nextCheck() -> Bool {
    return !(title.isEmpty || organization.isEmpty || content.isEmpty)
  }
}
// MARK: - 이미지 관리 EX
extension EditPostViewModel {
  
  // 기존 이미지 삭제
  func removeExistingImage(at index: Int) {
    guard existingImages.indices.contains(index) else { return }
    existingImages.remove(at: index)
    print("기존 이미지 삭제: \(index)")
  }
  
  // 새 이미지 삭제
  func removeNewImage(at index: Int) {
    guard selectedImagesData.indices.contains(index),
          selectedItems.indices.contains(index) else { return }
    
    selectedImagesData.remove(at: index)
    selectedItems.remove(at: index)
    print("새 이미지 삭제: \(index)")
  }
  
  @MainActor
  func loadSelectedImages(newItems: [PhotosPickerItem]) async {
    guard newItems.count != selectedImagesData.count else { return }
    
    let loadingTask = newItems.map { item in
      Task {
        try? await item.loadTransferable(type: Data.self)
      }
    }
    
    var imageData: [Data] = []
    for task in loadingTask {
      if let data = await task.value {
        imageData.append(data)
      }
    }
    
    selectedImagesData = imageData
  }
}

// MARK: - 업데이트 로직
extension EditPostViewModel {
  @MainActor
  func updatedPost() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let updatedPost = createUpdatedPost()
      _ = try await firestoreManager.update(updatedPost)
      
      await updateImages()
      print("공고 + 이미지 업데이트 성공")
    } catch {
      print("공고 수정 실패: \(error)")
    }
  }
  
  private func createUpdatedPost() -> Post {
    Post(
      postId: originalPost.postId,
      authorUserId: originalPost.authorUserId,
      title: title.trimmingCharacters(in: .whitespacesAndNewlines),
      organization: organization.trimmingCharacters(in: .whitespacesAndNewlines),
      content: content.trimmingCharacters(in: .whitespacesAndNewlines),
      recruitmentStart: originalPost.recruitmentStart,
      recruitmentEnd: Timestamp(date: endDate),
      status: originalPost.status,
      requiresName: originalPost.requiresName,
      requiresStudentId: originalPost.requiresStudentId,
      requiresDepartment: originalPost.requiresDepartment,
      requiresGender: originalPost.requiresGender,
      requiresAge: originalPost.requiresAge,
      requiresPhone: originalPost.requiresPhone,
      authorName: originalPost.authorName,
      authorOrganization: organization.trimmingCharacters(in: .whitespacesAndNewlines)
    )
  }
  
  private func updateImages() async {
    // 1. 기존 이미지들 모두 삭제
    for originalImage in originalImages {
      do {
        try await firestoreManager.delete(
          collectionType: .postImages,
          documentID: originalImage.imageId.uuidString
        )
      } catch {
        print("기존 이미지 삭제 실패: \(error)")
      }
    }
    
    var currentOrder = 0
    
    // 2. 남은 기존 이미지들 저장
    for existingImage in existingImages {
      // 기존 이미지는 URL 그대로 사용 (이미 Firebase에 있음)
      let newPostImage = PostImage(
        imageId: UUID(),
        postId: originalPost.postId.uuidString,
        imageUrl: existingImage.imageUrl,  // 원본 URL 사용
        imageOrder: currentOrder,
        createdAt: Timestamp()
      )
      
      do {
        _ = try await firestoreManager.create(newPostImage)
        currentOrder += 1
        print("기존 이미지 저장 완료: \(currentOrder-1)")
      } catch {
        print("기존 이미지 저장 실패")
      }
    }
    
    // 3. 새 이미지들 업로드 후 저장
    for newImageData in selectedImagesData {
      let imageId = UUID()
      let imageUrl = await fireStorageManager.uploadPostImage(
        data: newImageData,
        postId: originalPost.postId.uuidString,
        imageId: imageId.uuidString
      )
      
      let newPostImage = PostImage(
        imageId: imageId,
        postId: originalPost.postId.uuidString,
        imageUrl: imageUrl,
        imageOrder: currentOrder,
        createdAt: Timestamp()
      )
      
      do {
        _ = try await firestoreManager.create(newPostImage)
        currentOrder += 1
        print("새 이미지 저장 완료: \(currentOrder-1)")
      } catch {
        print("새 이미지 저장 실패")
      }
    }
  }
}
