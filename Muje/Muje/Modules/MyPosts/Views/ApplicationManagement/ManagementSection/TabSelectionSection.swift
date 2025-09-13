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
          .body1SemiBold16()
          .foregroundStyle(
            viewModel.selectedTab == .management ? Color.gray700 : Color.gray300
          )
          .frame(maxWidth: .infinity)
          
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              viewModel.selectedTab = .management
              viewModel.exitSelectionMode()
            }
          }
        Text("지원자 리스트")
          .body1SemiBold16()
          .foregroundStyle(
            viewModel.selectedTab == .list ? Color.gray700 : Color.gray300
          )
          .frame(maxWidth: .infinity)
          
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              viewModel.selectedTab = .list
              viewModel.exitSelectionMode()
            }
          }
      }
      .padding(.horizontal, 16)
      .padding(.top, 24)
      rectangle
    }
  }
  
  private var rectangle: some View {
    ZStack {
      Rectangle()
        .fill(Color.gray300)
        .frame(height: 2)
      GeometryReader { geometry in
        Rectangle()
          .fill(Color.gray700)
          .frame(width: geometry.size.width / 2, height: 2)
          .offset(x: viewModel.selectedTab == .management ? 0 : geometry.size.width / 2)
          .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTab)
      }
      .padding(.horizontal, 16)
      .frame(height: 2)
    }
  }
}
