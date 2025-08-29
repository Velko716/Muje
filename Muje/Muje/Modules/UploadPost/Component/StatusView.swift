//
//  StatusVIew.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct StatusView: View {
    @Binding var uploadPostViewModel: UploadPostViewModel
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 12) {
            HStack(spacing: 10) {
                ForEach(UploadPostStatus.allCases, id: \.self) { status in
                    if status == uploadPostViewModel.currentStatus {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 23)
                            .overlay(content: {
                                Text(status.postingLevel)
                                    .bold()
                                    .foregroundStyle(Color.white)
                            })
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 10)
                    }
                }
            }
            
            Text(uploadPostViewModel.currentStatus.postingTitle)
                .foregroundStyle(Color.black)
                .font(.title2)
                .bold()
        }
        .padding(.bottom, uploadPostViewModel.currentStatus == .interview ? 28 : 42)
    }
}

#Preview {
    StatusView(uploadPostViewModel: .constant(.init()))
}
