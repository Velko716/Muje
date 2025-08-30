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
            .init(title: "1. \(ReportType.insult.displayName)", content: ReportType.insult.displayName),
            .init(title: "2. \(ReportType.hateSpeech.displayName)", content: ReportType.hateSpeech.displayName),
            .init(title: "3. \(ReportType.sexualContent.displayName)", content: ReportType.sexualContent.displayName),
            .init(title: "4. \(ReportType.gambling.displayName)", content: ReportType.gambling.displayName),
            .init(title: "5. \(ReportType.spamAds.displayName)", content: ReportType.spamAds.displayName),
            .init(title: "6. \(ReportType.personalInfoLeak.displayName)", content: ReportType.personalInfoLeak.displayName),
            .init(title: "7. \(ReportType.impersonationOrFalse.displayName)", content: ReportType.impersonationOrFalse.displayName),
            .init(title: "8. \(ReportType.other.displayName)", content: ReportType.other.displayName)
        ]
    }
    
    deinit {
        self.selectedReason = ""
        self.detailText = ""
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
