//
//  tabSelection.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import SwiftUI

extension ApplicationManagementView {
  var tabSelctionSection: some View {
    VStack {
      HStack {
        Text("지원자 관리")
          .font(.headline)
          .fontWeight(viewModel.selectedTab == .management ? .bold : .medium)
          .foregroundStyle(viewModel.selectedTab == .management ? .primary : .secondary)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              viewModel.selectedTab = .management
            }
          }
        Text("지원자 리스트")
          .font(.headline)
          .fontWeight(viewModel.selectedTab == .list ? .bold : .medium)
          .foregroundStyle(viewModel.selectedTab == .list ? .primary : .secondary)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              viewModel.selectedTab = .list
            }
          }
      }
      .padding(.horizontal, 16)
      rectangle
    }
    
  }
  
  private var rectangle: some View {
    ZStack {
      Rectangle()
        .fill(Color.gray.opacity(0.3))
        .frame(height: 2)
    GeometryReader { geometry in
      Rectangle()
        .fill(Color.primary)
        .frame(width: geometry.size.width / 2, height: 2)
        .offset(x: viewModel.selectedTab == .management ? 0 : geometry.size.width / 2)
        .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTab)
    }
    .padding(.horizontal, 16)
    .frame(height: 2)
  }
  }
}
