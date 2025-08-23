//
//  RecruitPostCard.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct RecruitPostCard: View {
    var item: PostModel
    var isPost: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                InfoBox(name: item.title, title: item.content)
                HStack {
                    StatusCard(title: "모집 중", color: Color.green)
                    if item.hasInterview {
                        StatusCard(title: "면접 진행", color: Color.blue)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    DateBox(title: "모집 기간", startDate: item.startDate, endDate: item.endDate, isPost: true)
                    DateBox(title: "면접 일정", startDate: item.interviewStartDate, endDate: item.interviewEndDate, isPost: isPost)
                }
            }
            .padding(16)
            Divider()
                .padding(.bottom, 6)
            HStack {
                ButtonBox(title: "면접 일정", action: {
                    print("면접 일정 페이지로 이동")
                })
                
                Divider()
                ButtonBox(title: "지원자 관리", action: {
                    print("지원자 관리로 이동")
                })
                Divider()
                ButtonBox(title: "작성글 관리", action: {
                    print("공고 상세보기로 이동")
                })
            }
        }
        .padding(.bottom, 6)
        .background(content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
        })
    }
}

#Preview {
    RecruitPostCard(item: .init(title: "동아리명", content: "댄스 동아리 OO 모집합니다", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 7), interviewStartDate: Date().addingTimeInterval(3600 * 24 * 3), interviewEndDate: Date().addingTimeInterval(3600 * 24 * 5), hasInterview: true), isPost: true)
}
