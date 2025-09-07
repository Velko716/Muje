//
//  RecruitPostCard.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct RecruitPostCard: View {
    @EnvironmentObject private var router: NavigationRouter
    var item: Post
    var isPost: Bool

    
    var tempLists: [InterviewSlotModel] = []
  
    let thumbnailImage: PostImage?
  
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
              InfoBox(
                name: item.title,
                title: item.content,
                thumbnailImage: thumbnailImage
              )
                HStack {
                    StatusCard(title: "모집 중", color: Color.green)
                    if item.hasInterview {
                        StatusCard(title: "면접 진행", color: Color.blue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    DateBox(title: "모집 기간", startDate: item.recruitmentStart.dateValue(), endDate: item.recruitmentEnd.dateValue(), isPost: true)
                    DateBox(title: "면접 일정", startDate: tempLists.first?.interviewDate.dateValue(), endDate: tempLists.last?.interviewDate.dateValue(), isPost: isPost, hasInterview: item.hasInterview)
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
              ButtonBox(
                title: "지원자 관리",
                action: {
                  print("지원자 관리로 이동")
                  router.push(
                    to: .applicationManagementView(
                      postId: item.postId.uuidString,
                      postInfo: ApplicationManagementPostInfo(from: item)
                    )
                  )
                })
                Divider()
                ButtonBox(title: "작성글 관리", action: {
                    print("공고 상세보기로 이동")
                  router.push(to: .RecruitmentDetailView(postId: item.postId.uuidString))
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

//#Preview {
//    RecruitPostCard(item: .init(authorUserId: "qwer1234", title: "qwer", organization: "apple", content: "하이하이", recruitmentStart: Date(), recruitmentEnd: Date().addingTimeInterval(3600 * 24 * 5), hasInterview: true, interivewLocation: "도서관", status: "면접 전", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "One", authorOrganization: "Apple"), isPost: false)
//}
