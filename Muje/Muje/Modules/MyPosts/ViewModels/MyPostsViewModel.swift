//
//  MyPostsViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//
import SwiftUI

@Observable
class MyPostsViewModel {
    var recruitmentLists: [InterviewSlotModel] = [] //이후에 서버에서 받아오도록 변경_다가오는 일정에서 활용
    var applicationLists: [InterviewSlotModel] = [] //이후에 서버에서 받아오도록 변경_다가오는 일정에서 활용
    var recruitPosts: [PostModel] = [] //이후에 서버에서 받아오도록 변경_내가 올린 공고에 활용
    var applyPosts: [PostModel] = [] //이후에 서버에서 받아오도록 변경_내가 지원한 공고에 활용
    var isRecruit: Bool = false //모달 시트_다가오는 일정
    var isApply: Bool = false //모달 시트_다가오는 일정
    
    var currentRecruitPage: Int = 0
    var currentApplyPage: Int = 0
    
    func upcomingRecruitLists() -> [InterviewSlotModel] {
        let upcomingDates = recruitmentLists.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewDate && slot.interviewDate <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewDate < $1.interviewDate})
    
        return upcomingDates
    }
    
    func upcomingApplyLists() -> [InterviewSlotModel] {
        let upcomingDates = applicationLists.filter { slot in
            return Date().addingTimeInterval(-60) <= slot.interviewTime && slot.interviewTime <= Date().addingTimeInterval(3600 * 24)
        }.sorted(by: {$0.interviewTime < $1.interviewTime})
        return upcomingDates
    }
    
    //다가오는 일정에서 포맷 확인 함수
    func checkFirst(lists: [InterviewSlotModel], index: Int) -> Bool {
        if index < 1 {
            return true
        } else {
            if lists[index - 1].interviewDate.dateString == lists[index].interviewDate.dateString {
                return false
            } else {
                return true
            }
        }
    }
}
