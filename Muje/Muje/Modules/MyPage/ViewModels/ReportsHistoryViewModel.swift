//
//  ReportsHistoryViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import Foundation

@Observable
final class ReportsHistoryViewModel {
    
    
    // MARK: - 신고 생성 테스트 버튼 로직 (삭제 예정)
    func createReportTestButtonTapped() async {
        // 공고 신고 Model postId: "00DD1837-4416-46BD-8246-50CE26567717"
        let report = Report(
            reportId: UUID(),
            reporterUserId: FirebaseAuthManager.shared.currentUser?.userId ?? "",
            reportedUserId: "FTMIffTVLdb8GuhHweHJEgAwFqB2",
            postId: "00DD1837-4416-46BD-8246-50CE26567717",
            reportType: ReportType.spam.rawValue,
            status: ReportStatus.pending.rawValue
        )
        
        let _ = try? await FirestoreManager.shared.create(report)
    }
    
}
