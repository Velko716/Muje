//
//  TextViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/27/25.
//


/// 재사용되는 텍스트들을 모아 놓은 enum 파일입니다.
/// - communityRule: 커뮤니티 이용 규칙
/// - termsOfService: 서비스 이용약관
/// - privacyPolicy: 개인정보 처리 방침
/// - youthProtectionPolicy: 청소년 보호 정책
/// - openSourceLicenses: 오픈 소스 라이선스
enum TextViewType: String, CaseIterable, Identifiable {
    case communityRule // 커뮤니티 이용 규칙
    case termsOfService // 서비스 이용약관
    case privacyPolicy // 개인정보 처리 방침
    case youthProtectionPolicy // 청소년 보호 정책
    case openSourceLicenses // 오픈 소스 라이선스

    var id: String { rawValue }

    /// 화면 툴 바 타이틀
    var title: String {
        switch self {
        case .communityRule:
            return "커뮤니티 이용 규칙"
        case .termsOfService:
            return "서비스 이용약관"
        case .privacyPolicy:
            return "개인정보 처리 방침"
        case .youthProtectionPolicy: 
            return "청소년 보호 정책"
        case .openSourceLicenses:
            return "오픈 소스 라이선스"
        }
    }

    // TODO: 텍스트 노션에 업데이트시 텍스트 수정하기
    /// 내용
    var content: String {
        switch self {
        case .communityRule:
            return """
                    제1조 목적
                    제2조 정의
                    제3조 효력 및 변경
                    제4조 서비스 제공 (이용조건 및 절차)
                    제5조 게시물 삭제 관련
                    제6조 광고 게재
                    제7조 제한사항
                    """
        case .termsOfService:
            return "서비스 이용약관"
        case .privacyPolicy:
            return "개인정보 처리 방침"
        case .youthProtectionPolicy:
            return "청소년 보호 정책"
        case .openSourceLicenses:
            return "오픈 소스 라이선스"
        }
    }
}
