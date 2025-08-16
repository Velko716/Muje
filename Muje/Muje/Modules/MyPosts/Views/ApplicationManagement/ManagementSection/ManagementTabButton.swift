//
//  ManagementTabButton.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import SwiftUI

struct ManagementTabButton: View {
  
  @Bindable var viewModel: ApplicationManagementViewModel
  
  let isSelected: Bool
  let stage: ApplicationStatus
  
  var body: some View {
    HStack {
      Text("\(stage.displayName)")
        .font(.system(size: 16))
        .fontWeight(isSelected ? .bold : .medium)
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(isSelected ? Color.primary : Color.gray)
        .foregroundStyle(isSelected ? .white : .primary)
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.selectedManagementStage = stage
          }
        }
    }
    .padding(.vertical, 16)
  }
}

#Preview {
  ManagementTabButton(viewModel: ApplicationManagementViewModel(), isSelected: true, stage: .submitted)
}
