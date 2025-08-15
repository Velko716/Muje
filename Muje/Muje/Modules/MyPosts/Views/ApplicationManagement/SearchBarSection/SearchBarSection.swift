//
//  ContentSection.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import SwiftUI

extension ApplicationManagementView {
  
  var selectAndSearchBar: some View {
    VStack {
      if viewModel.isSelectionMode {
        HStack(spacing: 8) {
          Spacer()
          Button {
            viewModel.selectAll()
          } label: {
            Text(viewModel.selectedApplicantId.count == viewModel.filterApplicants.count ? "전체 해제" : "전체 선택")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
          Button {
            viewModel.isSelectionMode = false
            viewModel.selectedApplicantId.removeAll()
          } label: {
            Text("취소")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
        }
        .padding(.trailing, 16)
      } else {
        HStack(spacing: 8) {
          Spacer()
          Button {
            viewModel.isSelectionMode = true
          } label: {
            Text("선택")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
          Button {
            // TODO: - 리스트 검색 기능 구현
          } label: {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 100))
          }
        }
        .padding(.trailing, 16)
      }
    }
    .padding(.top, 8)
  }
  
  var searchBar: some View {
    HStack {
      Spacer()
      Button {
        // TODO: - 리스트 검색 기능 구현
      } label: {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 16))
          .padding(.vertical, 6)
          .padding(.horizontal, 8)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 100))
      }
    }
    .padding(.top, 16)
    .padding(.trailing, 16)
  }
}

