//
//  UpcomingCard.swift
//  Muje
//
//  Created by Air on 9/3/25.
//

import SwiftUI

struct UpcomingCard: View {
    @Binding var myPostsViewModel: MyPostsViewModel
    var title: String
    var codition: Bool
    var lists: [InterviewSlot]
    var isRecruitment: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            if lists.isEmpty {
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
                        Text("\(lists.count)건")
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Image(systemName: "chevron.up")
                            .foregroundStyle(Color.gray)
                    }
                    
                    Divider()
                    
                    ForEach(lists.indices, id: \.self) { idx in
                        if checkFirst(index: idx) {
                            HStack(spacing: 16) {
                                Text(myPostsViewModel.titleString(postId: lists[idx].postId, lists: checkLists()) ?? "오류")
                                    .foregroundStyle(Color.black)
                                Spacer()
                                Text(lists[idx].interviewDate.dateValue().listDateString)
                                    .foregroundStyle(Color.black)
                                Text(lists[idx].interviewTime)
                                    .foregroundStyle(Color.gray)
                                Text("\(lists[idx].currentReservations)명")
                                    .foregroundStyle(Color.gray)
                            }
                        } else {
                            HStack(spacing: 16) {
                                Spacer()
                                Text(lists[idx].interviewTime)
                                    .foregroundStyle(Color.gray)
                                Text("\(lists[idx].currentReservations)명")
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                    
                } else {
                    HStack(spacing: 16) {
                        Text(title)
                            .foregroundStyle(Color.black)
                        Text("\(lists.count)건")
                            .foregroundStyle(Color.gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .hvPadding(18, 16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
        )
    }
    
    func checkFirst(index: Int) -> Bool {
        if index < 1 {
            return true
        } else {
            if lists[index - 1].interviewDate.dateValue().dateString == lists[index].interviewDate.dateValue().dateString && (lists[index - 1].postId == lists[index].postId) {
                return false
            } else {
                return true
            }
        }
    }
    
    func checkLists() -> [Post] {
        return isRecruitment ? myPostsViewModel.uploadPost : myPostsViewModel.applicationPost
    }
}

#Preview {
    UpcomingCard(myPostsViewModel: .constant(.init()), title: "asd", codition: true, lists: [], isRecruitment: false)
}
