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
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollView {
          VStack {
            Divider()
              .background(Color.gray100)
            headerController
            calendarView
              .padding(.horizontal)
            if !interviewSlotViewModel.selectedSlots.isEmpty {
              slotSettingView
            }
            slotListView
              .padding()
          }
          .background(Color.white)
        }
        .navigationBarTitleDisplayMode(.inline)
        if !interviewSlotViewModel.selectedSlots.isEmpty {
          Button(action: {
              postInterviewViewModel.isSheet = false
          }, label: {
              ActionButton(title: "등록", condition: false)
                  .padding(.horizontal, 16)
          })
        }
      }
      .navigationTitle("면접 일정 설정")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {
            postInterviewViewModel.isSheet = false
          }) {
            Image(systemName: "xmark")
              .foregroundStyle(.gray700)
          }
        }
      }
    }
  }
  
  private var interviewSection: some View {
    VStack {
      HStack {
        
      }
    }
  }
  private var headerController: some View {
    HStack(spacing: 8, content: {
      Button(action: {
        calendarViewModel.changeMonth(by: -1)
      }, label: {
        Image(.iconChevronLeftActive)
          .foregroundStyle(.gray700)
      })
      
      Text(calendarViewModel.currentMonth, formatter: calendarViewModel.calendarHeaderDateFormatter)
        .subheadline20SemiBold()
        .foregroundStyle(.gray700)
      
      Button(action: {
        calendarViewModel.changeMonth(by: 1)
      }, label: {
        Image(.iconChevronRightActive)
          .foregroundStyle(.gray700)
      })
    })
  }
  
  private var calendarView: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.flexible()), count: 7),
      spacing: 5,
      content: {
        ForEach(calendarViewModel.localizedWeekdaysSymbols.indices, id: \.self) {
          index in
          Text(calendarViewModel.localizedWeekdaysSymbols[index])
            .caption14Medium()
            .foregroundStyle(.gray600)
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 30)
        
        ForEach(calendarViewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
          Button(
            action: {
              interviewSlotViewModel.toggleDate(calendarDay: calendarDay)
            },
            label: {
              CalendarCell(
                calendarDay: calendarDay,
                calendarViewModel: calendarViewModel,
                interviewSlotViewModel: interviewSlotViewModel,
                startDate: Calendar.current.date(byAdding: .day, value: -1, to: postInfoViewModel.startDate) ?? .now,
                endDate: postInfoViewModel.endDate
              )
            })
          .disabled(
            interviewSlotViewModel.checkSlot(
              date: calendarDay.date,
              startDate: Calendar.current.date(byAdding: .day, value: -1, to: postInfoViewModel.startDate) ?? .now,
              endDate: postInfoViewModel.endDate
            )
          )
        }
      })
    .frame(height: 250, alignment: .top)
  }
  
  private var slotSettingView: some View {
    VStack {
      Divider()
        .frame(height: 12)
        .background(Color.gray50)
        .padding(.horizontal, -24)
        .padding(.bottom)
      CountButton(
        value: $interviewSlotViewModel.timeInterval,
        title: "면접 시간",
        subTitle: "한 면접을 진행하는 시간",
        count: 10,
        unit: "분",
        condition: interviewSlotViewModel.timeInterval == 30
      )
      Spacer().frame(height: 32)
      CountButton(
        value: $interviewSlotViewModel.maxCount,
        title: "면접 인원",
        subTitle: "한 면접에 참여하는 지원자 수",
        count: 1,
        unit: "명"
      )
      Color.gray50.frame(height: 12).padding(.horizontal, -24)
        .padding(.top)
    }
    .padding(.horizontal)
    .onChange(of: interviewSlotViewModel.timeInterval) {
      interviewSlotViewModel.updateSlotsForNewTimeInterval()
    }
  }
  
  private var slotListView: some View {
    VStack(alignment: .leading, spacing: 16) {
      if interviewSlotViewModel.selectedSlots.isEmpty {
        delayView
      } else {
        ForEach(interviewSlotViewModel.groupedSlots.keys.sorted(), id: \.self) { day in
          VStack(alignment: .leading, spacing: 8) {
            Text(day.shortDateString)
              .body1Medium18()
              .foregroundStyle(.primaryBlack)
              .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(interviewSlotViewModel.groupedSlots[day] ?? [], id: \.id) { slot in
              let slots = interviewSlotViewModel.groupedSlots[day] ?? []
              let isLast = slot.id == slots.last?.id
              
              HStack {
                Button(action: {
                  interviewSlotViewModel.removeItem(withId: slot.id)
                }) {
                  Image(.iconRemove)
                }
                Spacer()
                Button(action: {
                  if let index = interviewSlotViewModel.selectedSlots.firstIndex(where: { $0.id == slot.id }) {
                    interviewSlotViewModel.selectedSlots[index].isStartShown.toggle()
                  }
                }) {
                  Text(slot.startTime.hourMinute24)
                    .body1Medium18()
                    .startPicker(
                      isShown: slot.isStartShown,
                      date: Binding(
                        get: { slot.startTime },
                        set: { newVal in
                          if let idx = interviewSlotViewModel.selectedSlots.firstIndex(where: { $0.id == slot.id }) {
                            interviewSlotViewModel.selectedSlots[idx].startTime = newVal
                          }
                        }
                      ),
                      onDismiss: {
                        if let index = interviewSlotViewModel.selectedSlots.firstIndex(where: { $0.id == slot.id }) {
                                  interviewSlotViewModel.selectedSlots[index].isStartShown = false
                                }
                      }
                    )
                    .foregroundStyle(Color.gray700)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(
                      RoundedRectangle(cornerRadius: 6)
                        .fill(slot.isStartShown ? Color.white : Color.gray100)
                    )
                }
                Text("~")
                Button(action: {
                  if let index = interviewSlotViewModel.selectedSlots.firstIndex(where: { $0.id == slot.id }) {
                    interviewSlotViewModel.selectedSlots[index].isEndShown.toggle()
                  }
                }) {
                  Text(slot.endTime.hourMinute24)
                    .body1Medium18()
                    .endPicker(
                      isShown: slot.isEndShown,
                      endTime: Binding(
                        get: { slot.endTime },
                        set: { newVal in
                          if let idx = interviewSlotViewModel.selectedSlots.firstIndex(where: { $0.id == slot.id }) {
                            interviewSlotViewModel.selectedSlots[idx].endTime = newVal
                          }
                        }
                      ),
                      lists: slot.timeLists
                    )
                    .foregroundStyle(Color.gray700)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 18)
                    .background(
                      RoundedRectangle(cornerRadius: 6)
                        .fill(slot.isEndShown ? Color.white : Color.gray100)
                    )
                }
                if isLast {
                  Button(action: {
                    interviewSlotViewModel.createPicker(
                      for: day,
                      startTime: slot.endTime
                    )
                  }) {
                    Image(.iconAddpdf)
                  }
                } else {
                  Color.clear
                    .frame(width: 24, height: 24)
                }
              }
              .padding(.vertical, 8)
              Divider()
            }
          }
        }
      }
    }
    .onChange(of: interviewSlotViewModel.selectedSlots) {
      interviewSlotViewModel.slotUpdate()
    }
  }
  
  private var delayView: some View {
    VStack {
      Text("날짜를 선택하세요")
        .body2Medium16()
        .foregroundStyle(.gray700)
        .padding(.vertical, 24)
      Text("공고 작성을 완료한 후에도\n면접일정을 설정할 수 있어요")
        .body1Medium16()
        .foregroundStyle(.gray700)
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
