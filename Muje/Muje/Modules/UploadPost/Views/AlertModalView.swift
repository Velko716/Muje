//
//  AlertModalView.swift
//  Muje
//
//  Created by Air on 8/25/25.
//

import SwiftUI

struct AlertModalView: View {
    @Binding var uploadPostViewModel: UploadPostViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text(uploadPostViewModel.alertContents[0])
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black)
                .frame(height: 60)
            
            Spacer()
            
            Button(action: {
                print(uploadPostViewModel.alertContents[1])
                uploadPostViewModel.isQuit = false
            }, label: {
                ActionButton(title: uploadPostViewModel.alertContents[1], condition: false)
            })
            
            Button(action: {
                uploadPostViewModel.isQuit = false
            }, label: {
                Text(uploadPostViewModel.alertContents[2])
                    .foregroundStyle(Color.gray)
            })
        }
        .hvPadding(16, 48)
        .presentationDragIndicator(.hidden)
        .presentationDetents([.height(240)])
    }
}

#Preview {
    AlertModalView(uploadPostViewModel: .constant(.init()))
}
