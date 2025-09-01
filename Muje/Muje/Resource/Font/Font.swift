//
//  Font.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI
import UIKit

extension Font {
    enum Pretendard {
        case bold
        case semiBold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .bold:
                return "Pretendard-Bold"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            }
        }
    }
    /// pretendard 폰트 생성 함수
    static func pretendard(type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static func lineHeight(type: Pretendard, fontSize: CGFloat, lineHeightPercent: CGFloat, letterSpacingPercent: CGFloat) -> (verticalPadding: CGFloat, letterSpacing: CGFloat) {
        // 실제 Pretendard 폰트로 lineHeight 구하기
        let uiFont = UIFont(name: type.value, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let fontLineHeight = uiFont.lineHeight
        
        // 피그마 lineHeight 계산
        let figmaLineHeight = fontSize * lineHeightPercent
        
        // letterSpacing 계산
        let letterSpacing = fontSize * (letterSpacingPercent / 100)
        
        // 위아래 패딩 계산 (lineHeight 차이를 패딩으로)
        let totalPadding = figmaLineHeight - fontLineHeight
        let verticalPadding = totalPadding / 3
        
        return (verticalPadding: verticalPadding, letterSpacing: letterSpacing)
    }
}
extension Text {
    //MARK: Headline
    func headline28Bold() -> some View {
        let config = Font.lineHeight(
            type: .bold,
            fontSize: 28,
            lineHeightPercent: 1.85,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .bold, size: 28))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func headline24Bold() -> some View {
        let config = Font.lineHeight(
            type: .bold,
            fontSize: 24,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .bold, size: 24))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func headline24SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 24,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .semiBold, size: 24))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    //MARK: SubHeadline
    func subheadline22Bold() -> some View {
        let config = Font.lineHeight(
            type: .bold,
            fontSize: 22,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .bold, size: 22))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func subheadline22semibold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 22,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .semiBold, size: 22))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func subheadline20medium() -> some View {
        let config = Font.lineHeight(
            type: .medium,
            fontSize: 20,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .medium, size: 20))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func subheadline20SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 20,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .semiBold, size: 20))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    //MARK: Body1
    func body1_18SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 18,
            lineHeightPercent: 1.5,
            letterSpacingPercent: -1
        )
        return self
            .font(.pretendard(type: .semiBold, size: 18))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body1_18Medium() -> some View {
        let config = Font.lineHeight(
            type: .medium,
            fontSize: 18,
            lineHeightPercent: 1.5,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .medium, size: 18))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body1_18Regular() -> some View {
        let config = Font.lineHeight(
            type: .regular,
            fontSize: 18,
            lineHeightPercent: 1.5,
            letterSpacingPercent: -1
        )
        return self
            .font(.pretendard(type: .regular, size: 18))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body1_16SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 16,
            lineHeightPercent: 1.5,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .semiBold, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body1_16Medium() -> some View {
        let config = Font.lineHeight(
            type: .medium,
            fontSize: 16,
            lineHeightPercent: 1.5,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .medium, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body1_16Regular() -> some View {
        let config = Font.lineHeight(
            type: .regular,
            fontSize: 16,
            lineHeightPercent: 1.5,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .regular, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    //MARK: Body2
    func body2_16SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 16,
            lineHeightPercent: 1.85,
            letterSpacingPercent: -1
        )
        return self
            .font(.pretendard(type: .semiBold, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func body2_16Medium() -> some View {
        let config = Font.lineHeight(
            type: .medium,
            fontSize: 16,
            lineHeightPercent: 1.85,
            letterSpacingPercent: -1
        )
        return self
            .font(.pretendard(type: .medium, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
        
    }
    func body2_16Regular() -> some View {
        let config = Font.lineHeight(
            type: .regular,
            fontSize: 16,
            lineHeightPercent: 1.85,
            letterSpacingPercent: -1
        )
        return self
            .font(.pretendard(type: .regular, size: 16))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
        
    }
    //MARK: Caption
    func caption14SemiBold() -> some View {
        let config = Font.lineHeight(
            type: .semiBold,
            fontSize: 14,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .semiBold, size: 14))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func caption14Medium() -> some View {
        let config = Font.lineHeight(
            type: .medium,
            fontSize: 14,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .medium, size: 14))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
        
    }
    func caption14Regular() -> some View {
        let config = Font.lineHeight(
            type: .regular,
            fontSize: 14,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .regular, size: 14))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func caption12Bold() -> some View {
        let config = Font.lineHeight(
            type: .bold,
            fontSize: 12,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .bold, size: 12))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
    func caption12Regular() -> some View {
        let config = Font.lineHeight(
            type: .regular,
            fontSize: 12,
            lineHeightPercent: 1.3,
            letterSpacingPercent: 0
        )
        return self
            .font(.pretendard(type: .regular, size: 12))
            .padding(.vertical, config.verticalPadding)
            .kerning(config.letterSpacing)
    }
}
