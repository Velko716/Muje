//
//  ReportView.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import SwiftUI

struct ReportView: View {
    @State private var viewModel: ReportViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                VStack(alignment: .leading) {
                    ReportReasonView(
                        viewModel: viewModel
                    )
                }
            }
            .toolbar {
                ToolbarLeadingXmarkBackButton()
                ToolbarCenterTitle(text: "신고하기")
            }
        }
    }
}


#Preview {
    NavigationStack {
        ReportView()
    }
}
