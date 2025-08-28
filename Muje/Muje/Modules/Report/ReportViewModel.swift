//
//  ReportViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import Foundation

struct ReportRow: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    let action: () -> Void
}

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
    
    let reportRow: [ReportRow] = [
        .init(title: "1. 욕설 및 비하 (종교, 장애, 성별 등)", action: { print("1") }),
        .init(title: "2. 폭력 및 혐오표현", action: { print("2") }),
        .init(title: "3.음란물 및 성적인 표현", action: { print("3") }),
        .init(title: "4. 도박 및 사행성 조장", action: { print("4") }),
        .init(title: "5. 스팸 및 광고", action: {}),
        .init(title: "6. 개인정보 유포", action: {}),
        .init(title: "7. 사정 및 허위 정보", action: {}),
        .init(title: "8. 기타", action: {}),
    ]
    
    
    
    
}
