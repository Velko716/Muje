//
//  InboxActionSheet.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import SwiftUI

struct InboxActionSheetView: View {
    var onReport: () -> Void
    var onBlock: () -> Void
    var onLeave: () -> Void
    var onClose: () -> Void

    @State private var appear = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 12) {
                // 카드
                VStack(spacing: 0) {
                    ActionRow(icon: "bell.badge", title: "신고하기") { onReport() }
                    Divider().padding(.leading, 56)
                    ActionRow(icon: "nosign", title: "차단하기") { onBlock() }
                    Divider().padding(.leading, 56)
                    ActionRow(icon: "trash", title: "채팅방 나가기",
                              titleColor: .red, iconTint: .red) { onLeave() }
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(uiColor: .systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.secondary.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                // 닫기 버튼
                Button(action: onClose) {
                    Text("닫기")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(uiColor: .systemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(.secondary.opacity(0.08), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .padding(.bottom, 8)
            .offset(y: appear ? 0 : 40)
            .opacity(appear ? 1 : 0)
            .animation(.spring(response: 0.32,
                               dampingFraction: 0.9,
                               blendDuration: 0.1),
                       value: appear)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear { appear = true }
    }
}

#Preview {
    InboxActionSheetView(
        onReport: {},
        onBlock: {},
        onLeave: {},
        onClose: {}
    )
}
