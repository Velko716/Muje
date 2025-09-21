//
//  BottomConfirmSheet.swift
//  Muje
//
//  Created by 김진혁 on 9/6/25.
//

import SwiftUI

struct BottomConfirmSheet: View {
    var title: String
    var primaryTitle: String
    var onPrimary: () -> Void
    var onCancel: () -> Void
    var showWarning: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.grayblack.opacity(0.5) // FIXME: - 수치 변환
                .ignoresSafeArea()
                .onTapGesture { onCancel() }
                .transition(.opacity)
            
            GeometryReader { proxy in
                let bottom = proxy.safeAreaInsets.bottom
                
                VStack(spacing: 40) {
                    Text(title)
                        .font(Font.pretendard(type: .semiBold, size: 20))
                        .foregroundStyle(.grayblack)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    // FIXME: - 버튼들 컴포넌트화 하기
                    VStack(spacing: 24) {
                        Button(action: onPrimary) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(showWarning ? Color.accentRed : Color.primaryBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .overlay {
                                    Text(primaryTitle)
                                        .font(
                                            Font.pretendard(
                                                type: .semiBold,
                                                size: 18
                                            )
                                        )
                                        .foregroundStyle(.graywhite)
                                }
                        }
                        Button(action: onCancel) {
                            Text("취소")
                                .font(Font.pretendard(type: .medium, size: 18))
                                .foregroundStyle(Color.gray600)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 48)
                .padding(.bottom, max(bottom, 12))
                .background(
                    // 시트 카드 배경: 상단만 둥근 흰색 패널
                    UnevenRoundedRectangle(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                        .fill(.white)
                        .ignoresSafeArea(edges: .bottom)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .zIndex(1000)
    }
}

#Preview {
    BottomConfirmSheet(title: "차단하기", primaryTitle: "취소") {
        
    } onCancel: {
        
    }
}
