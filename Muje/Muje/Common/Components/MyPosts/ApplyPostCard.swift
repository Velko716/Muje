//
//  ApplyPostCard.swift
//  Muje
//
//  Created by Air on 9/3/25.
//

import SwiftUI

struct ApplyPostCard: View {
    @Bindable var selectViewModel: SelectViewModel
    
    var item: PostModel
    var isPost: Bool
    var status: ApplicationStatus = .interviewWaiting //서버에서 어플리케이션 DTO 받아와서 패치
    var slotId: String? = nil //마찬가지로 어플리케이션 DTO 받아와서 패치
    
    var slot: InterviewSlotModel? //서버에서 인터뷰 슬롯 DTO들 받아와서 패치(어플리케이션 DTO에서 interviewSlotId를 찾은 후에 서버에서 동일한 id의 InterviewSlot DTO 받아오기)
    
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
                    DateBox(title: "모집 기간", startDate: item.recruitmentStart, endDate: item.recruitmentEnd, isPost: true)
                    DateBox(title: "면접 일정", startDate: slot?.interviewDate ?? nil, isPost: isPost, hasInterview: item.hasInterview)
                }
            }
            .padding(16)
            Divider()
                .padding(.bottom, 6)
            HStack {
                ButtonBox(title: status.buttonString(slotId: slotId), action: {
                    selectViewModel.isSetting = true
                }, condition: status.buttonStatus)
                .disabled(status.buttonStatus)
                
                Divider()
                ButtonBox(title: "공고글 보기", action: {
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
    ApplyPostCard(selectViewModel: .init(), item: .init(authorUserId: "1234", title: "댄스동아리 모집", organization: "애플", content: "안녕안녕", recruitmentStart: Date(), recruitmentEnd: Date().addingTimeInterval(3600 * 24 * 5), hasInterview: true, interivewLocation: "도서관", status: "면접 중", requiresName: true, requiresStudentId: true, requiresDepartment: true, requiresGender: true, requiresAge: true, requiresPhone: true, authorName: "hi", authorOrganization: "aaa"), isPost: true)
}
