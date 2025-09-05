//
//  InboxSendButton.swift
//  Muje
//
//  Created by 김진혁 on 8/16/25.
//

import SwiftUI

struct InboxSendButton: View {
    let sendEnabled: Bool
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "paperplane.fill") // FIXME: - 이미지 수정하기
                .padding(10)
                .foregroundStyle(Color.gray50)
                .imageScale(.medium)
                .background(sendEnabled ? Color.pointSkyBlue : Color.gray200 )
                .clipShape(Circle())
        }
    }
}

#Preview {
    InboxSendButton(sendEnabled: false) {
        print("SendButtonTapped")
    }
    .frame(width: 44, height: 44)
    
    
    InboxSendButton(sendEnabled: true) {
        print("SendButtonTapped")
    }
    .frame(width: 44, height: 44)
}
