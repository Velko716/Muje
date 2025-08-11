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
      Text("동아리명")
        .font(.caption)
        .fontWeight(.bold)
      Text("댄스 동아리 MAD 모집합니다.")
        .font(.title2)
        .fontWeight(.bold)
    }
  }
  
  private var statusSection: some View {
    HStack {
      Text("모집중")
        .font(.caption)
        .fontWeight(.bold)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.green.opacity(0.2))
        .foregroundStyle(.green)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      Text("면접 진행")
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
      Text("기간 기간 기간")
    }
  }
}
