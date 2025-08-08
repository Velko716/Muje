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
    VStack {
      postTitle
      postDate
      interviewDate
      Divider()
      content
    }
  }
}

extension RecruitmentDataView {
  private var postTitle: some View {
    VStack {
      Text(viewModel.post?.organization ?? "단체명 없음")
      Text(viewModel.post?.title ?? "공고 제목 없음")
      Text(viewModel.post?.status ?? "")
    }
  }
  
  private var postDate: some View {
    HStack {
      Text("모집 기간")
      Text(viewModel.post?.recruitmentStart.dateValue().shortDateString ?? "")
      Text("~")
      Text(viewModel.post?.recruitmentEnd.dateValue().shortDateString ?? "")
    }
  }
  
  private var interviewDate: some View {
    HStack {
      Text("면접 일정")
      Text(interviewScheduleText)
    }
  }
  
  private var interviewScheduleText: String {
    guard let period = viewModel.interviewperiod else {
      return "미정"
    }
    
    if period.start == period.end {
      return period.start.shortDateString
    } else {
      return "\(period.start.shortDateString)  ~  \(period.end.shortDateString)"
    }
  }
  
  private var content: some View {
    Text(viewModel.post?.content ?? "")
  }
}

#Preview {
  RecruitmentDataView(postId: "", viewModel: RecruitmentViewModel())
}
