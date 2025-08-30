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
                interviewSlotViewModel.updateAllSlot()
                interviewSlotViewModel.slotDebug()
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
                ForEach(Array($interviewSlotViewModel.selectedSlots.enumerated()), id: \.offset) { idx, slot in
                    HStack(spacing: 24) {
                        Button(action: {
                            interviewSlotViewModel.selectedSlots.remove(at: idx)
                        }, label: {
                            Image(systemName: "xmark")
                            
                        })
                        Spacer()
                        Text(interviewSlotViewModel.selectedSlots[idx].startTime.shortDateString)
                        Spacer()
                        Button(action: {
                            interviewSlotViewModel.selectedSlots[idx].isStartShown.toggle()
                        }, label: {
                            Text(interviewSlotViewModel.selectedSlots[idx].startTime.hourMinute24)
                                .startPicker(isShown: interviewSlotViewModel.selectedSlots[idx].isStartShown, date: slot.startTime)
                        })
                        Button(action: {
                            interviewSlotViewModel.selectedSlots[idx].isEndShown.toggle()
                        }, label: {
                            Text(interviewSlotViewModel.selectedSlots[idx].endTime.hourMinute24)
                                .endPicker(isShown: interviewSlotViewModel.selectedSlots[idx].isEndShown, endTime: slot.endTime, lists: interviewSlotViewModel.selectedSlots[idx].timeLists)
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
            Spacer()
            Text("공고 작성을 완료한 후에도 \n면접일정을 설정할 수 있어요")
            Button(action: {
                postInterviewViewModel.isSheet = false
            }, label: {
                Text("다음에 하기")
            })
        }
        .padding(.vertical, 18)
    }
}

#Preview {
    InterviewSlotView(postInfoViewModel: .init(), postInterviewViewModel: .init(), interviewSlotViewModel: .init())
}
