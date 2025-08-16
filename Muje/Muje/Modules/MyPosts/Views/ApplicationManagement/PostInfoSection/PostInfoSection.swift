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
        .font(.caption)
        .fontWeight(.bold)
      Text("\(postInfo.title)")
        .font(.title2)
        .fontWeight(.bold)
    }
  }
  
  private var statusSection: some View {
    HStack {
      Text("\(postInfo.status)")
        .font(.caption)
        .fontWeight(.bold)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.green.opacity(0.2))
        .foregroundStyle(.green)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      Text(postInfo.hasInterview ? "면접 진행" : "면접 없음")
        .font(.caption)
        .fontWeight(.bold)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.2))
        .foregroundStyle(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      Spacer()
    }
    .padding(.top, 12)
    .padding(.bottom, 4)
  }
  
  private var dateSection: some View {
    HStack(spacing: 16) {
      Text("모집 기간")
        .font(.subheadline)
        .foregroundStyle(.secondary)
      Text("\(postInfo.recruitmentStart.dateValue().shortDateString) ~ \(postInfo.recruitmentEnd.dateValue().shortDateString)")
    }
  }
}
