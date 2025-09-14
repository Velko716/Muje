//
//  AlertModalView.swift
//  Muje
//
//  Created by Air on 8/25/25.
//

import SwiftUI

struct AlertModalView: View {
    @Binding var uploadPostViewModel: UploadPostViewModel
  
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(uploadPostViewModel.alertContents[0])
                .subheadline20SemiBold()
                .multilineTextAlignment(.center)
                .foregroundStyle(.grayblack)
            
            Spacer().frame(height: 40)
            
            Button(action: {
                print(uploadPostViewModel.alertContents[1])
                uploadPostViewModel.isQuit = false
                action()
            }, label: {
                Text(uploadPostViewModel.alertContents[1])
                    .body1SemiBold18()
                    .foregroundStyle(.graywhite)
                    .padding(.vertical, 14.5)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.primaryBlack)
                    )
            })
            Spacer().frame(height: 24)
            Button(action: {
                uploadPostViewModel.isQuit = false
            }, label: {
                Text(uploadPostViewModel.alertContents[2])
                    .body1Medium18()
                    .foregroundStyle(.gray600)
                    .frame(maxWidth: .infinity)
            })
        }
        .hvPadding(16, 48)
        .presentationDragIndicator(.hidden)
        .presentationDetents([.height(295)])
    }
}

#Preview {
  AlertModalView(uploadPostViewModel: .constant(.init()), action: {})
}
