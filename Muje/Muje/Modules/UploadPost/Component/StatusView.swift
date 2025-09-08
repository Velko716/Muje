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
                            .fill(.pointSkyBlue)
                            .frame(width: 23)
                            .overlay(content: {
                                Text(status.postingLevel)
                                    .caption14SemiBold()
                                    .foregroundStyle(.graywhite)
                            })
                    } else {
                        Circle()
                            .fill(.gray100)
                            .frame(width: 10)
                    }
                }
            }
            
            Text(uploadPostViewModel.currentStatus.postingTitle)
                .headline24SemiBold()
                .foregroundStyle(.gray800)
        }
        .padding(.bottom, uploadPostViewModel.currentStatus.padding)
    }
}

#Preview {
    StatusView(uploadPostViewModel: .constant(.init()))
}
