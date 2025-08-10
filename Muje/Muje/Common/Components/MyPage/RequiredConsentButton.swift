//
//  RequiredConsentButton.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import SwiftUI

struct RequiredConsentButton: View {
    let title: String
    let checkAction: () -> ()
    let navigationAction: () -> ()
    
    var body: some View {
        HStack {
            Button {
                checkAction()
            } label: {
                Image(systemName: "checkmark")
            }
            
            Spacer().frame(width: 8)
            
            Button {
                navigationAction()
            } label: {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    RequiredConsentButton(title: "[필수] 이용약관에 동의합니다.") {
        print("checkAction")
    } navigationAction: {
        print("navigationAction")
    }
}
