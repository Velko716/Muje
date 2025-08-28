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
        NavigationStack { // 시트 뷰에 툴바를 구현하기 위해 임시 구현함.
            ZStack {
                Color.white
                VStack(alignment: .leading) {
                    topTitle
                        .paddingH16()
                    Spacer().frame(height: 32)
                    middleListView
                }
            }
            .toolbar {
                ToolbarLeadingBackButton() // FIXME: - Xmark로 교체하기
                ToolbarCenterTitle(text: "신고하기")
            }
        }
    }
    
    // MARK: - 탑 타이틀
    private var topTitle: some View {
        Text("신고사유를 선택해주세요")
            .font(Font.system(size: 22, weight: .semibold)) // FIXME: - 폰트 수정
            .foregroundStyle(Color.black) // FIXME: - 컬러 수정
    }
    
    // MARK: - 중간 리스트
    private var middleListView: some View {
        List {
            ForEach(viewModel.reportRow) { row in
                Button(action: row.action) {
                    Text(row.title)
                        .padding(.vertical, 16)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ReportView()
    }
}
