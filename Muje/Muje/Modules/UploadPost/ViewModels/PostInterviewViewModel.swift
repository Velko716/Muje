//
//  PostInterviewViewModel.swift
//  Muje
//
//  Created by Air on 8/25/25.
//

import SwiftUI

@Observable
class PostInterviewViewModel {
    var isSheet: Bool = false
    
    var hasInterview: Bool? = nil
    var interviewLocation: String = ""
    
    func nextCheck() -> Bool {
        return hasInterview == nil
    }
  
  func locationPass() -> String? {
    if interviewLocation.isEmpty {
      return nil
    } else {
      return interviewLocation
    }
  }
    
    func debug() {
        print("인터뷰 진행여부: \(hasInterview ?? false)")
        print("인터뷰 장소 \(interviewLocation)")
    }
}
