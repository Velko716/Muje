//
//  PostInfoSection.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import SwiftUI

extension ApplicationManagementView {
  var postInfoSection: some View {
    VStack(alignment: .leading, spacing: 4) {
      titleSection
      statusSection
      dateSection
    }
    .padding(.leading, 16)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading) {
      Text("\(postInfo.organization)")
        .body2Regular16()
        .foregroundStyle(.gray500)
      Text("\(postInfo.title)")
        .body1SemiBold18()
        .foregroundStyle(.gray700)
    }
  }
  
  private var statusSection: some View {
    HStack {
      if postInfo.status == "모집중" {
        StatusChip(status: .recruiting)
      } else {
        StatusChip(status: .completed)
      }
      if postInfo.hasInterview {
        StatusChip(status: .hasInterview)
      }
      Spacer()
    }
    .padding(.vertical, 8)
  }
  
  private var dateSection: some View {
    HStack(spacing: 16) {
      Text("모집 기간")
        .body2SemiBold16()
        .foregroundStyle(.gray500)
      Text("\(postInfo.recruitmentStart.dateValue().shortDateString) ~ \(postInfo.recruitmentEnd.dateValue().shortDateString)")
        .body2SemiBold16()
        .foregroundStyle(.gray700)
    }
  }
}
