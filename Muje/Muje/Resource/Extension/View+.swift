//
//  View+.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI

extension View {
    /// 네비게이션 이동 시 자동으로 생성되는 뒤로가기 버튼을 제거합니다.
    func hideBackButton() -> some View {
        self.navigationBarBackButtonHidden(true)
    }
    
    /// 아무 곳 터치 시, 키보드 창 내립니다.
    func dismissKeyboardOnTap() -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
            #if canImport(UIKit)
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            #endif
            }
    }
    
    /// 기본 여백 좌우 16입니다.
    func paddingH16() -> some View {
        self.padding(.horizontal, 16)
    }
    
    //토스트 형식 경고 컴포넌트 사용 모디파이어
    func toast(isShown: Binding<Bool>, message: String, alignment: Alignment = .bottom) -> some View {
        ZStack {
            self
            Toast(isShown: isShown, message: message)
            .opacity(
              isShown.wrappedValue ? 1 : 0
            )
            .animation(
              .easeInOut(duration: 0.3),
              value: isShown.wrappedValue
            )
        }
    }
    
    func startPicker(isShown: Bool, date: Binding<Date>) -> some View {
        ZStack {
            self
            if isShown {
                CustomDatePicker(date: date, minuteInterval: 5)
                    .frame(width: 200)
                    .background(Color.white)
            }
        }
    }
    
    func endPicker(isShown: Bool, endTime: Binding<Date>, lists: [Date]) -> some View {
        ZStack {
            self
            if isShown {
                Picker("", selection: endTime) {
                    ForEach(lists, id: \.self) { date in
                        Text(date.hourMinute24)
                            .tag(date)
                    }
                }
                .pickerStyle(.wheel)
                .background(Color.white)
            }
        }
    }
    
    //상하, 좌우 여백 통합 모디파이어 ex)hvPadding(12, 24) -> horizontal: 12, vertical: 24
    func hvPadding(_ h: CGFloat, _ v: CGFloat) -> some View {
            self
                .padding(.horizontal, h)
                .padding(.vertical, v)
        }
}
