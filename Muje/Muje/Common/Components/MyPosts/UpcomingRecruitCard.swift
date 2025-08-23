//
//  UpcomingRecruitCard.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct UpcomingRecruitCard: View {
    @Binding var myPostsViewModel: MyPostsViewModel
    var title: String
    var codition: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if myPostsViewModel.upcomingRecruitments.isEmpty {
                HStack {
                    Spacer()
                    Text("다가오는 일정이 없습니다.")
                        .foregroundStyle(Color.gray)
                    Spacer()
                }
            } else {
                if codition {
                    HStack(spacing: 16) {
                        Text(title)
                            .foregroundStyle(Color.black)
                        Text("\(myPostsViewModel.checkUpcomingCount())건")
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Image(systemName: "chevron.up")
                            .foregroundStyle(Color.gray)
                    }
                    
                    Divider()
                    
                    ForEach(myPostsViewModel.upcomingRecruitLists(), id: \.interviewDate) { list in
                        ForEach(list.timeLists, id: \.userID) { slot in
                            if checkFirst(list: list, slot: slot) {
                                HStack(spacing: 16) {
                                    Text(list.title)
                                        .foregroundStyle(Color.black)
                                    Spacer()
                                    Text(list.interviewDate.listDateString)
                                        .foregroundStyle(Color.black)
                                    Text(slot.interviewTime.hourMinute24)
                                        .foregroundStyle(Color.gray)
                                    Text("\(myPostsViewModel.checkPeopleCount(list: list.timeLists, time: slot.interviewTime))명")
                                        .foregroundStyle(Color.gray)
                                }
                            } else {
                                HStack(spacing: 16) {
                                    Spacer()
                                    Text(slot.interviewTime.hourMinute24)
                                        .foregroundStyle(Color.gray)
                                    Text("\(myPostsViewModel.checkPeopleCount(list: list.timeLists, time: slot.interviewTime))명")
                                        .foregroundStyle(Color.gray)
                                }
                            }
                        }
                    }
                    
                    
                    
                } else {
                    HStack(spacing: 16) {
                        Text(title)
                            .foregroundStyle(Color.black)
                        Text("\(myPostsViewModel.checkUpcomingCount())건")
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
        )
    }
    
    func checkFirst(list: RecruitModel, slot: InterviewTimeModel) -> Bool {
        if list.timeLists.count <= 1 {
            return true
        } else {
            return (list.timeLists.first == slot) ? true : false
        }
    }
    
}

#Preview {
    UpcomingRecruitCard(myPostsViewModel: .constant(.init()), title: "지원 면접", codition: true)
}
