//
//  ListSection.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import SwiftUI

extension ApplicationManagementView {
  // MARK: 지원자 관리 리스트
  var applicantManagementList: some View {
    VStack {
      let applicants = viewModel.getCurrentApplicant()
      
      if applicants.isEmpty {
        VStack {
          if viewModel.isSearching && !viewModel.searchText.isEmpty {
            Text("\(viewModel.searchText) 에 대한 검색 결과가 없습니다.")
              .multilineTextAlignment(.center)
              .foregroundStyle(.gray)
          } else {
            Text("\(viewModel.selectedManagementStage.displayName) 단계에\n지원자가 없습니다.")
              .multilineTextAlignment(.center)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
      } else {
        LazyVStack(alignment: .leading, spacing: 16) {
          ForEach(applicants, id: \.applicationId) { application in
            ApplicationManagementRow(
              viewModel: viewModel,
              isSelected: viewModel.selectedApplicantId.contains(application.applicationId),
              application: application
            )
          }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 12)
  }
  // MARK: - 지원자 전체 리스트
  var applicantFullList: some View {
    VStack {
      let applicants = viewModel.getCurrentApplicant()
      
      if applicants.isEmpty {
        VStack {
          if viewModel.isSearching && !viewModel.searchText.isEmpty {
            Text("\(viewModel.searchText) 에 대한 검색 결과가 없습니다.")
              .multilineTextAlignment(.center)
              .foregroundStyle(.gray)
          } else {
            Text("\(viewModel.selectedManagementStage.displayName) 단계에\n지원자가 없습니다.")
              .multilineTextAlignment(.center)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
      } else {
        LazyVStack(alignment: .leading, spacing: 16) {
          ForEach(applicants, id: \.applicationId) { application in
            ApplicantList(application: application)
              .padding(.vertical, 4)
          }
        }
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 12)
  }
}
