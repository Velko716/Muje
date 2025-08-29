//
//  ReportViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import Foundation

/*
 // MARK: - 신고 생성 테스트 버튼 로직 (삭제 예정)
 func createReportTestButtonTapped() async {
     // 공고 신고 Model postId: "00DD1837-4416-46BD-8246-50CE26567717"
     let report = Report(
         reportId: UUID(),
         reporterUserId: FirebaseAuthManager.shared.currentUser?.userId ?? "",
         reportedUserId: "FTMIffTVLdb8GuhHweHJEgAwFqB2",
         postId: "00DD1837-4416-46BD-8246-50CE26567717",
         reportType: ReportType.spam.rawValue,
         reason: "저한테 욕설을 빈번하게 사용했어요",
         status: ReportStatus.pending.rawValue
     )
     
     let _ = try? await FirestoreManager.shared.create(report)
 }
 */

@Observable
final class ReportViewModel {
    var selectedReason = ""
    var detailText = ""
    var reportRow: [ReportRow] = []

    init() {
        reportRow = [
            .init(title: "1. \(ReportType.insult.rawValue)", content: ReportType.insult.rawValue),
            .init(title: "2. \(ReportType.hateSpeech.rawValue)", content: ReportType.hateSpeech.rawValue),
            .init(title: "3. \(ReportType.sexualContent.rawValue)", content: ReportType.sexualContent.rawValue),
            .init(title: "4. \(ReportType.gambling.rawValue)", content: ReportType.gambling.rawValue),
            .init(title: "5. \(ReportType.spamAds.rawValue)", content: ReportType.spamAds.rawValue),
            .init(title: "6. \(ReportType.personalInfoLeak.rawValue)", content: ReportType.personalInfoLeak.rawValue),
            .init(title: "7. \(ReportType.impersonationOrFalse.rawValue)", content: ReportType.impersonationOrFalse.rawValue),
            .init(title: "8. \(ReportType.other.rawValue)", content: ReportType.other.rawValue)
        ]
    }
    
}
