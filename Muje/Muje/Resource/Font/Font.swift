//
//  Font.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

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
}
extension Text {
    static var percent185: CGFloat { 1.85 }
    static var percent150: CGFloat { 1.5 }
    static var percent140: CGFloat { 1.4 }
    static var percent130: CGFloat { 1.3 }
    
    static func lineHeight(fontSize: CGFloat, lineHeightPercent: CGFloat) -> CGFloat {
        return (fontSize * (lineHeightPercent - 1))
    }
    
    //MARK: Headline
    func headline28Bold() -> some View {
        return self
            .font(.pretendard(type: .bold, size: 28))
            .lineSpacing(Text.lineHeight(fontSize: 28, lineHeightPercent: Text.percent140))
    }
    func headline24Bold() -> some View {
        return self
            .font(.pretendard(type: .bold, size: 24))
            .lineSpacing(Text.lineHeight(fontSize: 24, lineHeightPercent: Text.percent130))
    }
    func headline24SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 24))
            .lineSpacing(Text.lineHeight(fontSize: 24, lineHeightPercent: Text.percent130))
    }
    //MARK: SubHeadline
    func subheadline22Bold() -> some View {
        return self
            .font(.pretendard(type: .bold, size: 22))
            .lineSpacing(Text.lineHeight(fontSize: 22, lineHeightPercent: Text.percent130))
    }
    func subheadline22semibold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 22))
            .lineSpacing(Text.lineHeight(fontSize: 22, lineHeightPercent: Text.percent130))
    }
    func subheadline20medium() -> some View {
        return self
            .font(.pretendard(type: .medium, size: 20))
            .lineSpacing(Text.lineHeight(fontSize: 20, lineHeightPercent: Text.percent130))
    }
    func subheadline20SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 20))
            .lineSpacing(Text.lineHeight(fontSize: 20, lineHeightPercent: Text.percent130))
    }
    //MARK: Body1
    func body1_18SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 18))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    func body1_18Medium() -> some View {
        return self
            .font(.pretendard(type: .medium, size: 18))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    func body1_18Regular() -> some View {
        return self
            .font(.pretendard(type: .regular, size: 18))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    func body1_16SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    func body1_16Medium() -> some View {
        return self
            .font(.pretendard(type: .medium, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    func body1_16Regular() -> some View {
        return self
            .font(.pretendard(type: .regular, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 18, lineHeightPercent: Text.percent150))
    }
    //MARK: Body2
    func body2_16SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 16, lineHeightPercent: Text.percent185))
    }
    func body2_16Medium() -> some View {
        return self
            .font(.pretendard(type: .medium, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 16, lineHeightPercent: Text.percent185))
    }
    func body2_16Regular() -> some View {
        return self
            .font(.pretendard(type: .regular, size: 16))
            .lineSpacing(Text.lineHeight(fontSize: 16, lineHeightPercent: Text.percent185))
    }
    //MARK: Caption
    func caption14SemiBold() -> some View {
        return self
            .font(.pretendard(type: .semiBold, size: 14))
            .lineSpacing(Text.lineHeight(fontSize: 14, lineHeightPercent: Text.percent130))
    }
    func caption14Medium() -> some View {
        return self
            .font(.pretendard(type: .medium, size: 14))
            .lineSpacing(Text.lineHeight(fontSize: 14, lineHeightPercent: Text.percent130))
    }
    func caption14Regular() -> some View {
        return self
            .font(.pretendard(type: .regular, size: 14))
            .lineSpacing(Text.lineHeight(fontSize: 14, lineHeightPercent: Text.percent130))
    }
    func caption12Bold() -> some View {
        return self
            .font(.pretendard(type: .bold, size: 12))
            .lineSpacing(Text.lineHeight(fontSize: 14, lineHeightPercent: Text.percent130))
    }
    func caption12Regular() -> some View {
        return self
            .font(.pretendard(type: .regular, size: 12))
            .lineSpacing(Text.lineHeight(fontSize: 14, lineHeightPercent: Text.percent130))
    }
}
