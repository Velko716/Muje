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
                        .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
                        .foregroundStyle(Color.black) // FIXME: - 컬러 수정
                }
            }
            .paddingH16()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "확인",
                    textColor: Color.white, // FIXME: - 컬러 수정
                    bgColor: Color.black, // FIXME: - 컬러 수정
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
