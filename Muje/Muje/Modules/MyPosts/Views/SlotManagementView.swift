//
//  SlotManagement.swift
//  Muje
//
//  Created by Air on 9/13/25.
//

import SwiftUI
import FirebaseFirestore

struct SlotManagementView: View {
    @State var calendarViewModel: CalendarViewModel = .init()
    @State var interviewSlotViewModel: InterviewSlotViewModel = .init()
    @State var uploadPostViewModel: UploadPostViewModel = .init()
    
    var item: Post
  
    let slot: [InterviewSlot]?
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24, content: {
                    headerController
                    
                    calendarView
                    
                    if interviewSlotViewModel.selectedSlots.isEmpty {
                        Text("날짜를 선택하세요")
                            .padding(.top, 120)
                    } else {
                        slotSettingView
                        
                        slotListView
                    }
                })
                .hvPadding(16, 30)
                .background(Color.white)
                .toolbar {
                    ToolbarLeadingBackButton()
                    ToolbarCenterTitle(text: "면접 일정 열기")
                }
            }
            Button(action: {
                Task {
                    await interviewSlotViewModel.saveTimeModel(for: item.postId.uuidString)
                }
                dismiss()
            }, label: {
                ActionButton(title: "등록", condition: false)
                    .padding(.horizontal, 16)
            })
        }
        .task {
            await interviewSlotViewModel.loadTimeModel(for: item.postId.uuidString)
            interviewSlotViewModel.slotUpdate()
        }
    }
    
    private var headerController: some View {
        HStack(spacing: 47, content: {
            Button(action: {
                calendarViewModel.changeMonth(by: -1)
            }, label: {
                Image(systemName: "chevron.left")
            })
            
            Text(calendarViewModel.currentMonth, formatter: calendarViewModel.calendarHeaderDateFormatter)
                .font(.title3)
                .foregroundStyle(Color.black)
            
            Button(action: {
                calendarViewModel.changeMonth(by: 1)
            }, label: {
                Image(systemName: "chevron.right")
            })
        })
    }
    
    private var calendarView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5, content: {
            ForEach(calendarViewModel.localizedWeekdaysSymbols.indices, id: \.self) { index in
                Text(calendarViewModel.localizedWeekdaysSymbols[index])
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
            .padding(.bottom, 30)
            
            ForEach(calendarViewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                Button(action: {
                    interviewSlotViewModel.createPicker(calendarDay: calendarDay)
                }, label: {
                    Cell(calendarDay: calendarDay, calendarViewModel: calendarViewModel, startDate: item.recruitmentStart.dateValue(), endDate: item.recruitmentEnd.dateValue())
                })
                .disabled(interviewSlotViewModel.checkSlot(date: calendarDay.date, startDate: item.recruitmentStart.dateValue(), endDate: item.recruitmentEnd.dateValue()))
            }
        })
        .frame(height: 250, alignment: .top)
    }
    
    private var slotSettingView: some View {
        HStack {
          CountButton(value: $interviewSlotViewModel.maxCount, title: "면접 시간", subTitle: "한 면접을 진행하는 시간", count: 1, unit: "분")
            
            Spacer()
            
          CountButton(value: $interviewSlotViewModel.timeInterval, title: "면접 인원", subTitle: "한 면접에 참여하는 지원자 수", count: 10, unit: "분", condition: interviewSlotViewModel.timeInterval == 30)
        }
        .padding(.horizontal, 24)
        .onChange(of: interviewSlotViewModel.timeInterval) {
            interviewSlotViewModel.selectedSlots.removeAll()
        }
    }
    
    private var slotListView: some View {
        VStack {
            ForEach($interviewSlotViewModel.selectedSlots, id: \.timeId) { $slot in
                ListCardView(interviewSlotViewModel: interviewSlotViewModel, slot: $slot)
            }
        }
        .onChange(of: interviewSlotViewModel.selectedSlots) {
            interviewSlotViewModel.slotUpdate()
        }
    }
}

//#Preview {
//    SlotManagementView(item: .init(postId: .init(), authorUserId: "sad", title: "qsdsdqq", organization: "asfdx", content: "sdnjask", recruitmentStart: .init(), recruitmentEnd: .init(date: Date().addingTimeInterval(3600 * 24 * 7)), status: "모집중", authorName: "sda", authorOrganization: "zzz"))
//}
