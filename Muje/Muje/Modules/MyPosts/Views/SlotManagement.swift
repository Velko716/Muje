//
//  SlotManagement.swift
//  Muje
//
//  Created by Air on 9/13/25.
//

import SwiftUI

struct SlotManagementView: View {
    @State var calendarViewModel: CalendarViewModel = .init()
    @State var interviewSlotViewModel: InterviewSlotViewModel = .init()
    @State var uploadPostViewModel: UploadPostViewModel = .init()
    
    var item: Post
    
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
                //여기에 서버에 인터뷰 슬롯들 올리는 메서드 추가
                Task {
                    await uploadPostViewModel.createInterviewSlot(postId: item.postId.uuidString, interviewSlotViewModel: interviewSlotViewModel)
                }
                dismiss()
            }, label: {
                ActionButton(title: "등록", condition: false)
                    .padding(.horizontal, 16)
            })
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
            CountButton(value: $interviewSlotViewModel.maxCount, title: "한 타임 당 면접 인원", count: 1, unit: "명")
            
            Spacer()
            
            CountButton(value: $interviewSlotViewModel.timeInterval, title: "한 타임 당 면접 시간", count: 10, unit: "분", condition: interviewSlotViewModel.timeInterval == 30)
        }
        .padding(.horizontal, 24)
        .onChange(of: interviewSlotViewModel.timeInterval) {
            interviewSlotViewModel.selectedSlots.removeAll()
        }
    }
    
    private var slotListView: some View {
        VStack {
            ForEach($interviewSlotViewModel.selectedSlots, id: \.id) { slot in
                HStack(spacing: 24) {
                    Button(action: {
                        interviewSlotViewModel.removeItem(withId: slot.id)
                    }, label: {
                        Image(systemName: "xmark")
                        
                    })
                    Spacer()
                    Text(slot.wrappedValue.startTime.shortDateString)
                    Spacer()
                    Button(action: {
                        slot.wrappedValue.isStartShown.toggle()
                    }, label: {
                        Text(slot.wrappedValue.startTime.hourMinute24)
                            .startPicker(isShown: slot.wrappedValue.isStartShown, date: slot.startTime)
                    })
                    Button(action: {
                        slot.wrappedValue.isEndShown.toggle()
                    }, label: {
                        Text(slot.wrappedValue.endTime.hourMinute24)
                            .endPicker(isShown: slot.wrappedValue.isEndShown, endTime: slot.endTime, lists: slot.wrappedValue.timeLists)
                    })
                    .onChange(of: slot.startTime.wrappedValue) {
                        interviewSlotViewModel.updateSlotTime(slot: slot)
                    }
                }
                .padding()
            }
        }
        .onChange(of: interviewSlotViewModel.selectedSlots) {
            interviewSlotViewModel.slotUpdate()
        }
    }
}

#Preview {
    SlotManagementView(item: .init(postId: .init(), authorUserId: "sad", title: "qsdsdqq", organization: "asfdx", content: "sdnjask", recruitmentStart: .init(), recruitmentEnd: .init(date: Date().addingTimeInterval(3600 * 24 * 7)), status: "모집중", authorName: "sda", authorOrganization: "zzz"))
}
