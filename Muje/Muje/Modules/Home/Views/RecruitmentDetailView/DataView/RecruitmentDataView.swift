//
//  RecruitmentDataView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct RecruitmentDataView: View {
    let postId: String
    @Bindable var viewModel: RecruitmentViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            postTitle
            postDate
            interviewDate
            divider()
            content
            divider()
            //TODO: infoSection 공통으로 관리할 수 있도록 추가하기
        }
        .padding(.horizontal, 16)
    }
    
    private var postTitle: some View {
        VStack(alignment: .leading) {
            Text(viewModel.post?.organization ?? "단체명 없음")
                .caption14Medium()
                .foregroundStyle(.gray400)
            Spacer().frame(height: 4)
            Text(viewModel.post?.title ?? "공고 제목 없음")
                .subheadline22semibold()
                .foregroundStyle(.gray700)
            Spacer().frame(height: 8)
            HStack {
                (viewModel.post?.status == "모집중")
                    ? StatusChip(status: .recruiting)
                    : StatusChip(status: .completed)
                if viewModel.post?.hasInterview == true {
                    StatusChip(status: .hasInterview)
                }
            }
        }
        .padding(.bottom, 24)
    }
    private var postDate: some View {
        RecruitmentInfo(
         info: "모집 기간",
         content: viewModel.post?.recruitmentStart.dateValue().shortDateString ?? "" + " ~ " + (viewModel.post?.recruitmentEnd.dateValue().shortDateString ?? "")
        )
    }
    private var interviewDate: some View {
        RecruitmentInfo(info: "면접 일정", content: interviewScheduleText)
    }
    private var interviewScheduleText: String {
        guard let period = viewModel.interviewperiod else {
            return "추후 공지 예정"
        }
        
        if period.start == period.end {
            return period.start.shortDateString
        } else {
            return "\(period.start.shortDateString)  ~  \(period.end.shortDateString)"
        }
    }
    private var interviewPlace: some View {
        RecruitmentInfo(info: "면접 장소", content: viewModel.post?.interviewLocation ?? "")
    }
    private var content: some View {
        Text(viewModel.post?.content ?? "")
            .body2Regular16()
            .foregroundStyle(.gray700)
    }
}
//#Preview {
//    RecruitmentDataView(postId: "", viewModel: RecruitmentViewModel())
//}
