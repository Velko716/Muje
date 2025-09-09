//
//  ApplicationSubmitCompleteView.swift
//  Muje
//
//  Created by 김서현 on 9/6/25.
//

import SwiftUI

struct ApplicationSubmitCompleteView: View {
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var tabSelection: TabSelection
    var body: some View {
        VStack {
            TopTextView
            Spacer()
            graphicsView
            Spacer()
        }
        .toolbar {
            ToolbarCenterTitle(text: "신청서 작성")
        }
        TwoActionBottomButton(
            leftAction: {
                router.popToRootView()
                tabSelection.tabCase = .myPosts
            } ,
            leftText: "나의 모임페이지",
            rightAction: { router.popToRootView() },
            rightText: "홈으로"
        )
    }
    private var TopTextView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("신청서가 제출되었어요!")
                    .headline24SemiBold()
                    .foregroundStyle(.gray700)
                Text("모집자에게 신청이 전달되었어요\n합격 발표 알림을 기다려주세요")
                    .body1Regular16()
                    .foregroundStyle(.gray500)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            Spacer()
        }
    }
    
    private var graphicsView: some View {
        Image(.temp)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 79.5)
    }

}

#Preview {
    ApplicationSubmitCompleteView()
}
