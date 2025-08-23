//
//  FireStorageManager.swift
//  Muje
//
//  Created by 조재훈 on 8/21/25.
//

import Foundation
import FirebaseStorage

class FireStorageManager {
  static let shared = FireStorageManager()
  private init() {}
  
  // MARK: - path -> url로 변환 함수
  func getDownloadURL(for path: String) async throws -> String {
    let storageRef = Storage.storage().reference().child(path)
    let url = try await storageRef.downloadURL()
    return url.absoluteString
  }
  // MARK: - 공고 이미지 스토리지에 업로드 함수
  func uploadPostImage(
    data: Data,
    postId: String,
    imageId: String
  ) async -> String {
    
    let path = "post_images/\(postId)/\(imageId).jpg" // 안드쪽에서 설정했다는 경로
    
    do {
      let storageRef = Storage.storage().reference().child(path)
      let _ = try await storageRef.putDataAsync(data)
      
      print("공고 이미지 스토리지 업로드 성공")
      return path
    } catch {
      print("공고 이미지 스토리지 업로드 실패")
      return ""
    }
  }
  // MARK: - 공고 이미지 스토리지에서 삭제 함수
  func deleteFile(at path: String) async -> Bool {
    do {
      let storegeRef = Storage.storage().reference().child(path)
      try await storegeRef.delete()
      print("공고 이미지 삭제 성공: \(path)")
      return true
    } catch {
      print("삭제 실패 \(error)")
      return false
    }
  }
}

