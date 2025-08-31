//
//  BottomBarBackgroundModifier.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI


struct BottomBarBackgroundModifier: ViewModifier {
    var fill: Color = Color.white.opacity(0.95)
    var shadowColor: Color = Color.black.opacity(0.05)
    var radius: CGFloat = 15
    var x: CGFloat = 0
    var y: CGFloat = -4
    var edges: Edge.Set = .bottom

    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(fill)
                    .shadow(color: shadowColor, radius: radius, x: x, y: y)
                    .ignoresSafeArea(edges: edges)
            )
    }
}

extension View {
    /// 하단 고정 바 배경 + 그림자(Figma: X 0, Y -4, Blur 15, #000 5%)
    func bottomBarBackground(
        fill: Color = Color.white.opacity(0.95),
        shadowColor: Color = Color.black.opacity(0.05),
        radius: CGFloat = 15,
        x: CGFloat = 0,
        y: CGFloat = -4,
        edges: Edge.Set = .bottom
    ) -> some View {
        modifier(
            BottomBarBackgroundModifier(
                fill: fill,
                shadowColor: shadowColor,
                radius: radius,
                x: x,
                y: y,
                edges: edges
            )
        )
    }
}
