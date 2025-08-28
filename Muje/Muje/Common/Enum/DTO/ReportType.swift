//
//  ReportType.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

enum ReportType: String, Codable {
    case insult = "욕설 및 비하 (종교, 장애, 성별 등)"
    case hateSpeech = "폭력 및 혐오표현"
    case sexualContent = "음란물 및 성적인 표현"
    case gambling = "도박 및 사행성 조장"
    case spamAds = "스팸 및 광고"
    case personalInfoLeak = "개인정보 유포"
    case impersonationOrFalse = "사칭 및 허위 정보"
    case other = "기타"
}
