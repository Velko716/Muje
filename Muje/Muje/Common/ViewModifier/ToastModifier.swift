//
//  ToastModifier.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI

struct ToastModifier<ToastContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var duration: TimeInterval = 2.0
    var position: ToastPosition = .bottom
    var tapToDismiss: Bool = true
    var bottomPadding: CGFloat = 0
    @ViewBuilder var toast: () -> ToastContent
    
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: position.alignment) {
                GeometryReader { proxy in
                    if isPresented {
                        toast()
                            .transition(.move(edge: position == .top ? .top : (position == .bottom ? .bottom : .bottom))
                                .combined(with: .opacity))
                            .padding(.horizontal, 16)
                            .padding(.bottom, position == .bottom
                                     ? (16 + proxy.safeAreaInsets.bottom + bottomPadding)
                                     : 0)
                            .padding(.top, position == .top
                                     ? (16 + proxy.safeAreaInsets.top)
                                     : 0)
                            .onAppear { scheduleAutoHide() }
                            .onChange(of: isPresented) { scheduleAutoHide() }
                            .onTapGesture { if tapToDismiss { dismiss() } }
                    }
                }
            }
            .animation(.snappy, value: isPresented)
    }
    
    private func scheduleAutoHide() {
        workItem?.cancel()
        guard isPresented, duration > 0 else { return }
        let item = DispatchWorkItem { dismiss() }
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: item)
    }
    
    private func dismiss() {
        workItem?.cancel()
        withAnimation { isPresented = false }
        #if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}


extension View {
    func toast<T: View>(
        isPresented: Binding<Bool>,
        duration: TimeInterval = 2.0,
        position: ToastPosition = .bottom,
        tapToDismiss: Bool = true,
        bottomPadding: CGFloat = 0,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        modifier(ToastModifier(isPresented: isPresented,
                               duration: duration,
                               position: position,
                               tapToDismiss: tapToDismiss,
                               bottomPadding: bottomPadding,
                               toast: content))
    }
}

