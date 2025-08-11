//
//  ApplicationManagementView.swift
//  Muje
//
//  Created by 조재훈 on 8/11/25.
//

import SwiftUI

struct ApplicationManagementView: View {
  
  @State var selectedTab: ApplicationTab = .management
  @State var selectedManagementStage: ManagementStage = .submitted
  
  let postId: String
  
  var body: some View {
    VStack {
      CustomNavigationBar(
        title: "내가 올린 공고") {
          // 네비게이션 연결
        }
      
      postInfoSection
      tabSelctionSection
      contentSection
    }
  }
  

}

#Preview {
  ApplicationManagementView(postId: "post_id")
}
