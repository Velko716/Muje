//
//  TopButtonView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct TopButtonView: View {
    @State private var showReportModal: Bool = false
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                backButton
                Spacer()
                DropButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 100)
            Spacer()
        }
    }
    
    private var DropButton: some View {
        Button {
            showReportModal = true
        } label: {
            Image(systemName: "text.append")
        }
        .sheet(isPresented: $showReportModal) {
            ReportModalView(showReportModal: $showReportModal)
                .presentationDetents([.fraction(0.2)])
                .presentationCornerRadius(20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var backButton: some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 24))
                .padding()
                .foregroundStyle(.black)
                .background(
                    Rectangle()
                        .fill(Color.clear)
                )
        }
        
    }
}

//#Preview {
//  TopButtonView(action: {})
//}
