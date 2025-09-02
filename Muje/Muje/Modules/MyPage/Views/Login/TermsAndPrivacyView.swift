//
//  TermsAndPrivacyView.swift
//  Muje
//
//  Created by 김진혁 on 9/2/25.
//

import SwiftUI

struct TermsAndPrivacyView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    let legalDocumentType: LegalDocumentType
    
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
                    router.pop()
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
        TermsAndPrivacyView(legalDocumentType: .privacyPolicy)
    }
}
