//
//  RecruitmentDetailView.swift
//  Muje
//
//  Created by 조재훈 on 8/6/25.
//

import SwiftUI

struct RecruitmentDetailView: View {
  
  private let viewModel = RecruitmentViewModel.shared
  
  var body: some View {
    ZStack {
      ScrollView {
        ImageView(postImage: <#[PostImage]#>)
      }
    }
  }
}

#Preview {
  RecruitmentDetailView()
}
