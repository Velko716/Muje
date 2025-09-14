//
//  TermsAndPrivacyView.swift
//  Muje
//
//  Created by 김진혁 on 9/2/25.
//

import SwiftUI

struct TermsAndPrivacyView: View {
    
    let legalDocumentType: LegalDocumentType
    @Binding var termsAgreed: Bool
    @Binding var privacyAgreed: Bool
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                VStack {
                    Text(legalDocumentType.content)
                        .font(Font.pretendard(type: .medium, size:16))
                        .foregroundStyle(Color.gray700)
                        .lineSpacing(13.6)
                        .kerning(-0.16)
                }
            }
            .paddingH16()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "확인",
                    textColor: Color.white,
                    bgColor: Color.primaryBlack,
                    enabled: true
                ) {
                    switch legalDocumentType {
                    case .termsOfService:
                        self.termsAgreed = true
                    case .privacyPolicy:
                        self.privacyAgreed = true
                    }
                    dismiss()
                }
            }
            .bottomBarBackground() // ViewModifier
        }
        .toolbar {
            ToolbarLeadingXmarkBackButton()
            ToolbarCenterTitle(text: legalDocumentType.title)
        }
    }
}

#Preview {
    NavigationStack {
        TermsAndPrivacyView(
            legalDocumentType: .privacyPolicy,
            termsAgreed: .constant(false),
            privacyAgreed: .constant(false)
        )
        .environmentObject(NavigationRouter())
    }
}
