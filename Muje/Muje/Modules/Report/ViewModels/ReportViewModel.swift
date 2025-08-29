//
//  ReportViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import Foundation

@Observable
final class ReportViewModel {
    var selectedReason = ""
    var detailText = ""
    var reportRow: [ReportRow] = []
    
    // FIXME: - 임시 (신고 변수)
    var reportedUserId: String?
    var conversationId: String?
    
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
    
    
    // MARK: - 신고 생성 (채팅)
    func createReport(reportedUserId: String, conversationId: String) async {
        let report = Report(
            reportId: UUID(),
            reporterUserId: FirebaseAuthManager.shared.currentUser?.userId ?? "",
            reportedUserId: reportedUserId,
            conversationId: conversationId,
            reportType: self.selectedReason,
            reason: self.detailText,
            status: ReportStatus.pending.rawValue
        )
        let _ = try? await FirestoreManager.shared.create(report)
    }
    
    
}
