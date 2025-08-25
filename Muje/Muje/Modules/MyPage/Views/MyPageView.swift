//
//  MyPageView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    private var sections: [MyPageSection] {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        return [
            .init(header: "커뮤니티", rows: [
                .init(kind: .action(title: "신고 내역", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "차단 내역", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "커뮤니티 이용 규칙", action: { router.push(to: .contentView )})) // FIXME: - 라우터 변경
            ]),
            .init(header: "이용 안내", rows: [
                .init(kind: .value(title: "앱 버전", value: appVersion)), // FIXME: - 라우터 변경
                .init(kind: .action(title: "문의하기", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "서비스 이용약관", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "개인정보 처리 방침", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "청소년 보호 정책", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "오픈 소스 라이선스", action: { router.push(to: .contentView )})) // FIXME: - 라우터 변경
            ]),
            .init(header: "기타", rows: [
                .init(kind: .action(title: "정보 동의 설정", action: { router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(title: "로그아웃", action: { /* logout */ })), // FIXME: - 라우터 변경
                .init(kind: .action(title: "회원 탈퇴", action: { /* withdraw */ })) // FIXME: - 라우터 변경
            ])
        ]
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                topUserInfoView
                    .paddingH16()
                List {
                    ForEach(sections) { section in
                        Section {
                            ForEach(section.rows) { row in
                                rowView(row)
                            }
                            .listRowBackground(Color(.secondarySystemBackground)) // FIXME: - Gray 50으로 색상 변경
                        } header: {
                            headerView(section.header)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .listStyle(.insetGrouped)
            }
            .toolbar {
                ToolbarLeadingBackButton()
                ToolbarCenterTitle(text: "설정")
            }
        }
        
    }
    
    // MARK: - 탑) 유저 정보 입력 뷰
    private var topUserInfoView: some View {
        // 로그인 여부에 대한 분기 처리
        VStack(alignment: .leading) {
            if let user = FirebaseAuthManager.shared.currentUser {
                // FIXME: - 디자인 수정 (폰트, 컬러)
                Text(user.name)
                    .font(Font.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.black)
                Spacer().frame(height: 8)
                Text(user.department)
                    .font(Font.system(size: 16))
                    .foregroundStyle(Color.gray)
                Text(user.studentId)
                    .font(Font.system(size: 16))
                    .foregroundStyle(Color.gray)
            } else {
                Button {
                    router.push(to: .emailVerificationView)
                } label: {
                    HStack(spacing: .zero) {
                        Text("로그인 해주세요")
                            .font(Font.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.black)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.black)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
    
    
    // MARK: - 리스트 header 아이템
    @ViewBuilder
    private func headerView(_ headerText: String) -> some View {
        VStack {
            Text(headerText)
                .font(Font.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.black) // FIXME: - Gray 700 수정
                .offset(x: -20) // FIXME: - 더 좋은 방법으로 수정하기
            Spacer().frame(height: 8)
        } //: VSTACK
    }
    
    
    // MARK: - 리스트 row 아이템
    @ViewBuilder
    private func rowView(_ row: MyPageRow) -> some View {
        switch row.kind {
        case .value(let title, let value):
            LabeledContent {
                Text(value)
                    .foregroundStyle(.secondary) // FIXME: - 컬러 수정
            } label: {
                Text(title)
                    .settingListItem(color: Color.black) // FIXME: - Gray700 수정
            }
        case .action(let title, let action):
            Button {
                action()
            } label: {
                LabeledContent {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray) // FIXME: - Gray 500 수정
                        .frame(width: 24, height: 24)
                } label: {
                    Text(title)
                        .settingListItem(
                            color: title == "회원 탈퇴" ? Color.red : Color.black // FIXME: - Accent red, Gray700 수정
                        )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(NavigationRouter())
    }
}
