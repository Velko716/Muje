//
//  Date.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import Foundation

extension Date {
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        
        return formatter.string(from: self)
    }
    
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        
        return formatter.string(from: self)
    }
    
    var hourMinute24: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // MARK: - 1분 미만=방금 전, 1주 이내=상대시간, 그 외 = 날짜
    func listTimeLabel(now: Date = .now) -> String {
        let diff = now.timeIntervalSince(self)

        if diff < 0 { return "방금 전" }
        
        // 1분 미만
        if diff < 60 {
            return "방금 전"
        }
        
        // 1주 이내는 상대 시간
        if diff < 7 * 24 * 60 * 60 {
            let r = RelativeDateTimeFormatter()
            r.locale = Locale(identifier: "ko_KR")
            r.unitsStyle = .full           // "13분 전", "1시간 전", "어제"
            r.calendar = Calendar(identifier: .gregorian)
            return r.localizedString(for: self, relativeTo: now)
        }
        
        // 1주 초과: 같은 해면 "M월 d일", 해가 다르면 "yyyy. M. d."
        let cal = Calendar.current
        let sameYear = cal.component(.year, from: self) == cal.component(.year, from: now)
        
        let df = Date.cachedDateFormatter
        df.locale = .current
        df.dateFormat = sameYear ? "M월 d일" : "yyyy. M. d."
        return df.string(from: self)
    }
    
    private static let cachedDateFormatter: DateFormatter = {
        let f = DateFormatter()
        return f
    }()
}
