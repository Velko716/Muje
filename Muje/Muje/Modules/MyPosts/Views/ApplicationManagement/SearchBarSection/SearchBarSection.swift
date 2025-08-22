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
      if viewModel.isSearching {
        expandedSearchBar
      } else if viewModel.isSelectionMode {
        selectionModeBar
      } else {
        normalModeBar
      }
    }
//    .padding(.top, 4)
  }
  
  var searchBar: some View {
    VStack {
      if viewModel.isSearching {
        expandedSearchBar
      } else {
        normalSearchButton
      }
    }
  }
  // MARK: - 전체 리스트 검색바
  var normalSearchButton: some View {
    HStack {
      Spacer()
      Button {
        viewModel.startSearching()
      } label: {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 16))
          .padding(.vertical, 6)
          .padding(.horizontal, 8)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 100))
      }
    }
    .padding(.top, 10)
    .padding(.trailing, 16)
  }
  // MARK: - 선택모드
  private var selectionModeBar: some View {
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

  }
  // MARK: - 일반모드
  private var normalModeBar: some View {
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
        viewModel.startSearching()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          isSearchFieldFocused = true
        }
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
    .padding(.top, 10)
  }
  // MARK: - 검색할때 검색바
  private var expandedSearchBar: some View {
    HStack {
      Button {
        viewModel.endSearching()
        isSearchFieldFocused = false
      } label: {
        Image(systemName: "chevron.left")
          .foregroundStyle(.blue)
          .font(.title2)
      }
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(.gray)
        
        TextField(placeholderText, text: $viewModel.searchText)
          .textFieldStyle(PlainTextFieldStyle())
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              UIApplication.shared.sendAction(
                #selector(UIResponder.becomeFirstResponder),
                to: nil,
                from: nil,
                for: nil
              )
            }
          }
        
        if !viewModel.searchText.isEmpty {
          Button {
            viewModel.searchText = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.gray)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color(.systemGray6))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .padding(.horizontal, 16)
    .padding(.top, 2)
    .padding(.vertical, 12)
    .background(Color.white)
    .transition(.move(edge: .trailing))
  }
  
  private var placeholderText: String {
    switch viewModel.selectedTab {
    case .management:
      return "이름, 학과, 학번으로 검색"
    case .list:
      return "전체 지원자 검색"
    }
  }
}

