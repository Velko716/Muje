//
//  InterviewSlotView.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct InterviewSlotView: View {
    @State var calendarViewModel: CalendarViewModel = .init()
    
    @Bindable var postInfoViewModel: PostInfoViewModel
    @Bindable var postInterviewViewModel: PostInterviewViewModel
    @Bindable var interviewSlotViewModel: InterviewSlotViewModel
        
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24, content: {
                    headerController
                    
                    calendarView
                    
                    slotSettingView
                    
                    slotListView
                })
                .hvPadding(16, 30)
                .background(Color.white)
            }
            
            Button(action: {
                postInterviewViewModel.isSheet = false
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
                Image(.chevronLeft)
                    .foregroundStyle(.gray700)
            })
            
            Text(calendarViewModel.currentMonth, formatter: calendarViewModel.calendarHeaderDateFormatter)
                .subheadline20SemiBold()
                .foregroundStyle(.gray700)
            
            Button(action: {
                calendarViewModel.changeMonth(by: 1)
            }, label: {
                Image(.chevronRight)
                    .foregroundStyle(.gray700)
            })
        })
    }
    
    private var calendarView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5, content: {
            ForEach(calendarViewModel.localizedWeekdaysSymbols.indices, id: \.self) { index in
                Text(calendarViewModel.localizedWeekdaysSymbols[index])
                    .caption14Medium()
                    .foregroundStyle(.gray300)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 30)
            
            ForEach(calendarViewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                Button(action: {
                    interviewSlotViewModel.createPicker(calendarDay: calendarDay)
                }, label: {
                    Cell(calendarDay: calendarDay, calendarViewModel: calendarViewModel, startDate: postInfoViewModel.startDate, endDate: postInfoViewModel.endDate)
                })
                .disabled(interviewSlotViewModel.checkSlot(date: calendarDay.date, startDate: postInfoViewModel.startDate, endDate: postInfoViewModel.endDate))
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
            if interviewSlotViewModel.selectedSlots.isEmpty {
                delayView
            } else {
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
        }
        .onChange(of: interviewSlotViewModel.selectedSlots) {
            interviewSlotViewModel.slotUpdate()
        }
    }
    
    private var delayView: some View {
        VStack(spacing: 24) {
            Text("날짜를 선택하세요")
                .body2Medium16()
                .foregroundStyle(.gray700)
            Spacer().frame(height: 24)
            Text("공고 작성을 완료한 후에도\n면접일정을 설정할 수 있어요")
                .body1Medium16()
                .foregroundStyle(.gray700)
            Spacer().frame(height: 16)
            Button(action: {
                postInterviewViewModel.isSheet = false
            }, label: {
                Text("다음에 하기")
                    .body2Medium16()
                    .foregroundStyle(.pointSkyBlue)
            })
        }
    }
}

#Preview {
    InterviewSlotView(postInfoViewModel: .init(), postInterviewViewModel: .init(), interviewSlotViewModel: .init())
}
