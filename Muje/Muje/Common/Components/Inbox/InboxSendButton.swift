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
            Image(systemName: "paperplane.fill")
                .padding(10)
                .foregroundStyle(sendEnabled ? Color.white : .secondary)
                .imageScale(.medium)
                .background(sendEnabled ? Color.accentColor : Color.secondary.opacity(0.2))
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
