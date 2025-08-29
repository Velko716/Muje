//
//  ReportsHistoryViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import Foundation

@Observable
final class ReportsHistoryViewModel {
    
    var reports: [Report] = []
    var isLoading: Bool = false
        
    // MARK: - report 데이터 불러오기
    @MainActor
    func loadReportData() async {
        print("currentUser: \(FirebaseAuthManager.shared.currentUser?.userId ?? "없음")")
        isLoading = true
        defer { isLoading = false }
        do {
            print("rawValue: \(Report.CodingKeys.reporterUserId.rawValue)")
            let reports: [Report] = try await FirestoreManager.shared.fetchAll(
                FirebaseAuthManager.shared.currentUser?.userId ?? "",
                from: .reports,
                where: Report.CodingKeys.reporterUserId.rawValue,
                orderBy: Report.CodingKeys.createdAt.rawValue,
            )
            self.reports = reports
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 신고 생성 테스트 버튼 로직 (삭제 예정)
    func createReportTestButtonTapped() async {
        // 공고 신고 Model postId: "00DD1837-4416-46BD-8246-50CE26567717"
//        let report = Report(
//            reportId: UUID(),
//            reporterUserId: FirebaseAuthManager.shared.currentUser?.userId ?? "",
//            reportedUserId: "FTMIffTVLdb8GuhHweHJEgAwFqB2",
//            postId: "00DD1837-4416-46BD-8246-50CE26567717",
//            reportType: ReportType.spam.rawValue,
//            reason: "저한테 욕설을 빈번하게 사용했어요",
//            status: ReportStatus.pending.rawValue
//        )
//        
//        let _ = try? await FirestoreManager.shared.create(report)
    }
    
}
