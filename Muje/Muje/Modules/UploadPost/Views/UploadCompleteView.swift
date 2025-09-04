//
//  UploadCompleteView.swift
//  Muje
//
//  Created by 조재훈 on 8/30/25.
//

import SwiftUI

struct UploadCompleteView: View {
  @EnvironmentObject private var router: NavigationRouter
  
  var body: some View {
    VStack(alignment: .leading) {
      title
      Spacer()
      grapics
      Spacer()
    }
    .padding(.top, 32)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .safeAreaInset(edge: .bottom, content: {
      bottomButton
    })
    .navigationTitle("모임 올리기")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private var title: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("모임이 등록되었어요!")
        .font(.title2)
        .foregroundStyle(Color.black)
        .bold()
      Text("모집 기간동안 공고가 노출돼요\n작성한 내용은 공고 현황 탭에서 관리할 수 있어요")
        .font(.system(size: 14))
        .foregroundStyle(.gray)
        .lineSpacing(3)
    }
  }
  
  private var grapics: some View {
    VStack {
      Text("그래픽 어떻게 넣는거지?")
    }
  }
  
  private var bottomButton: some View {
    HStack {
      Button {
        router.push(to: .myPostView)
      } label: {
        Text("나의 모임 페이지")
          .padding()
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.gray)
          )
      }
      Button {
        router.popToRootView()
      } label: {
        Text("홈으로")
          .padding()
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.black)
          )
      }
    }
    .hvPadding(16, 20)
    .frame(maxWidth: .infinity)
    .background(
      Rectangle()
        .fill(Color.white)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .bottom)
    )
    
  }
}

#Preview {
  UploadCompleteView()
}
