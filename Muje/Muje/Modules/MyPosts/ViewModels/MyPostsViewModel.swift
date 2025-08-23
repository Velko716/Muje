//
//  MyPostsViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

@Observable
class MyPostsViewModel {
    var upcomingRecruitments: [RecruitModel] = RecruitmentsList.lists //이후에 서버에서 받아오도록 변경
    var upcomingApplications: [InterviewTimeModel] = ApplicationsList.lists //이후에 서버에서 받아오도록 변경
    var recruitPosts: [PostModel] = RecruitPosts.lists
    var applyPosts: [PostModel] = ApplyPosts.lists
    var isRecruit: Bool = false
    var isApply: Bool = false
    
    var currentRecruitPage: Int = 0
    var currentApplyPage: Int = 0
    
    
    func checkPeopleCount(list: [InterviewTimeModel], time: Date) -> Int {
        var count = 0
        for item in list {
            if item.interviewTime == time {
                count += 1
            }
        }
        return count
    }
    
    func checkUpcomingCount() -> Int {
        var count = 0
        let upcomingDates = upcomingRecruitments.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewDate && slot.interviewDate <= Date().addingTimeInterval(3600 * 24)
        }
        for list in upcomingDates {
            count += list.timeLists.count
        }
        return count
    }
    
    
    func upcomingRecruitLists() -> [RecruitModel] {
        let upcomingDates = upcomingRecruitments.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewDate && slot.interviewDate <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewDate < $1.interviewDate})
    
        return upcomingDates
    }
    
    func upcomingApplyLists() -> [InterviewTimeModel] {
        let upcomingDates = upcomingApplications.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewTime && slot.interviewTime <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewTime < $1.interviewTime})
        return upcomingDates
    }
}




final class RecruitmentsList {
    static let lists: [RecruitModel] = [
        .init(title: "댄스 동아리", interviewDate: Date(), maxCapacity: 3, timeLists: [
            .init(userID: "qwer", interviewTime: Date(), title: "댄스 동아리"),
            .init(userID: "asdf", interviewTime: Date().addingTimeInterval(1800), title: "댄스 동아리"),
            .init(userID: "zxcv", interviewTime: Date().addingTimeInterval(3600), title: "댄스 동아리")
        ]),
        .init(title: "컴퓨터 동아리", interviewDate: Date().addingTimeInterval(3600 * 23), maxCapacity: 2, timeLists: [
            .init(userID: "wert", interviewTime: Date().addingTimeInterval(3600 * 23), title: "컴퓨터 동아리"),
            .init(userID: "sdfg", interviewTime: Date().addingTimeInterval(3600 * 23), title: "컴퓨터 동아리"),
            .init(userID: "xcvb", interviewTime: Date().addingTimeInterval(3600 * 23 + 1800), title: "컴퓨터 동아리"),
            .init(userID: "erty", interviewTime: Date().addingTimeInterval(3600 * 23 + 3600), title: "컴퓨터 동아리")
        ]),
        .init(title: "롤 동아리", interviewDate: Date().addingTimeInterval(3600 * 24 * 3), maxCapacity: 5, timeLists: [
        ])
    ]
}

final class ApplicationsList {
    static let lists: [InterviewTimeModel] = [
        .init(userID: "qwer", interviewTime: Date(), title: "댄스 동아리"),
        .init(userID: "asdf", interviewTime: Date().addingTimeInterval(3600 * 24 * 7), title: "컴퓨터 동아리")
    ]
}

final class RecruitPosts {
    static let lists: [PostModel] = [
        .init(title: "댄스 동아리", content: "댄스 동아리 OO모집합니다", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 14), interviewStartDate: Date().addingTimeInterval(3600 * 24 * 3), interviewEndDate: Date().addingTimeInterval(3600 * 24 * 7), hasInterview: true),
        .init(title: "롤 동아리", content: "롤 동아리 OO모집합니다", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 7), hasInterview: false)
    ]
}

final class ApplyPosts {
    static let lists: [PostModel] = [
        .init(title: "컴퓨터 동아리", content: "컴퓨터 동아리 XX입니다", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 5), hasInterview: true)
    ]
}
