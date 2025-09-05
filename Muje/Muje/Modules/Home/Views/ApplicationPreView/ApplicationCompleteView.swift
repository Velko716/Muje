//
//  UploadCompleteView.swift
//  Muje
//
//  Created by 조재훈 on 8/30/25.
//

import SwiftUI

struct ApplicationCompleteView: View {
  @EnvironmentObject private var router: NavigationRouter
  @EnvironmentObject private var tabSelection: TabSelection
  
  var body: some View {
    VStack(alignment: .leading) {
      title
      Spacer()
      grapics
      Spacer()
    }
    .toolbar {
      ToolbarCenterTitle(text: "신청서 작성")
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
      Text("신청서가 제출되었어요!")
        .font(.title2)
        .foregroundStyle(Color.black)
        .bold()
      Text("모집자에게 신청이 전달되었어요\n합격 발표 알림을 기다려주세요")
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
        router.popToRootView()
        tabSelection.tabCase = .myPosts
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
  NavigationStack {
    ApplicationCompleteView()
  }
  .environmentObject(NavigationRouter())
}
