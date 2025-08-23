//
//  EditViewModel.swift (팀원 스타일로 간단하게!)
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

@Observable
class EditViewModel {
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
  var endDateString: String = "마감일 선택"
  var isPicker: Bool = false
  
  // MARK: - 이미지 관련 (팀원 스타일!)
  var selectedPhotos: [PhotosPickerItem] = []
  var existingImages: [PostImage] = []  // 기존 이미지들
  var newImagesData: [Data] = []        // 새로 선택한 이미지들
  
  init(post: Post, postImages: [PostImage]) {
    self.originalPost = post
    self.originalImages = postImages.sorted { $0.imageOrder < $1.imageOrder }
    self.existingImages = self.originalImages  // 초기에는 기존 이미지들로 설정
    
    self.title = post.title
    self.organization = post.organization
    self.content = post.content
    self.startDate = post.recruitmentStart.dateValue()
    self.endDate = post.recruitmentEnd.dateValue()
  }
  
  var dateRange: ClosedRange<Date> {
    let min = Date()
    let max = Date().addingTimeInterval(60 * 60 * 24 * 365)
    return min...max
  }
  
  func nextCheck() -> Bool {
    return !(title.isEmpty || organization.isEmpty || content.isEmpty)
  }
  
  // 전체 이미지 개수 (기존 + 새로운)
  var totalImageCount: Int {
    existingImages.count + newImagesData.count
  }
}

// MARK: - 이미지 로직 (팀원 스타일!)
extension EditViewModel {
  
  /// 기존 이미지 삭제
  func removeExistingImage(at index: Int) {
    guard existingImages.indices.contains(index) else { return }
    existingImages.remove(at: index)
    print("기존 이미지 삭제: \(index)")
  }
  
  /// 새 이미지 삭제 (팀원과 똑같은 방식!)
  func removeNewImage(at index: Int) {
    guard newImagesData.indices.contains(index),
          selectedPhotos.indices.contains(index) else { return }
    
    newImagesData.remove(at: index)
    selectedPhotos.remove(at: index)
    print("새 이미지 삭제: \(index)")
  }
  
  /// 새 이미지 로드 (팀원과 똑같은 방식!)
  @MainActor
  func loadNewImages(with newItems: [PhotosPickerItem]) async {
    newImagesData.removeAll()
    
    let loadingTasks = newItems.map { item in
      Task {
        try? await item.loadTransferable(type: Data.self)
      }
    }
    
    var imageData: [Data] = []
    for task in loadingTasks {
      if let data = await task.value {
        imageData.append(data)
      }
    }
    
    newImagesData = imageData
    print("새 이미지 로드 완료: \(newImagesData.count)개")
  }
}

// MARK: - 업데이트 로직
extension EditViewModel {
  @MainActor
  func updatedPost() async {
    do {
      let updatedPost = createUpdatedPost()
      _ = try await firestoreManager.update(updatedPost)
      
      await updateImages()
      print("공고 업데이트 성공")
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
        print("이미지 삭제 실패: \(error)")
      }
    }
    
    var currentOrder = 0
    
    // 2. 남은 기존 이미지들 저장
    for existingImage in existingImages {
      let newPostImage = PostImage(
        imageId: UUID(),
        postId: originalPost.postId.uuidString,
        imageUrl: existingImage.imageUrl,
        imageOrder: currentOrder,
        createdAt: Timestamp()
      )
      
      do {
        _ = try await firestoreManager.create(newPostImage)
        currentOrder += 1
        print("기존 이미지 저장: \(currentOrder-1)")
      } catch {
        print("기존 이미지 저장 실패")
      }
    }
    
    // 3. 새 이미지들 업로드 후 저장
    for newImageData in newImagesData {
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
        print("새 이미지 저장: \(currentOrder-1)")
      } catch {
        print("새 이미지 저장 실패")
      }
    }
  }
}
