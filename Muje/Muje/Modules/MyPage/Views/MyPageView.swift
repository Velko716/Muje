//
//  MyPageView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var auth: FirebaseAuthManager
    @Environment(\.openURL) private var openURL
    @State private var viewModel: MyPageViewModel = .init()
    
    @State private var showLogoutAlert: Bool = false
    @State private var showWithdrawAlert: Bool = false
    
    private var sections: [MyPageSection] {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        var result: [MyPageSection] = [
            .init(header: "", rows: [
                .init(kind: .action(id: "notif", title: "알림 설정", action: { viewModel.openAppNotificationSettings(using: openURL) })),
            ]),
            .init(header: "커뮤니티", rows: [
                .init(kind: .action(id: "reports", title: "신고 내역", action: { router.push(to: .reportsHistoryView )})),
                .init(kind: .action(id: "blocks", title: "차단 내역", action: { router.push(to: .blockHistoryView )})),
                .init(kind: .action(id: "communityRule", title: "커뮤니티 이용 규칙", action: { router.push(to: .textView(type: .communityRule) )}))
            ]),
            .init(header: "이용 안내", rows: [
                .init(kind: .value(title: "앱 버전", value: appVersion)),
                .init(kind: .action(id: "contact", title: "문의하기", action: { print("문의하기"); router.push(to: .contentView )})), // FIXME: - 라우터 변경
                .init(kind: .action(id: "tos", title: "서비스 이용약관", action: { router.push(to: .textView(type: .termsOfService) )})),
                .init(kind: .action(id: "privacy", title: "개인정보 처리 방침", action: { router.push(to: .textView(type: .privacyPolicy) )})),
                .init(kind: .action(id: "youth", title: "청소년 보호 정책", action: { router.push(to: .textView(type: .youthProtectionPolicy) )})),
                .init(kind: .action(id: "oss", title: "오픈 소스 라이선스", action: { router.push(to: .textView(type: .openSourceLicenses) )}))
            ]),
        ]
        if auth.currentUser != nil {
            result.append(.init(
                header: "기타",
                rows: [
                    .init(kind: .action(id: "consent", title: "정보 동의 설정", action: { router.push(to: .contentView )})),
                    // FIXME: - 라우터 변경
                    .init(kind: .action(id: "logout", title: "로그아웃", action: { showLogoutAlert = true })),
                    .init(kind: .action(id: "withdraw", title: "회원 탈퇴", action: { showWithdrawAlert = true })) // FIXME: - 라우터 변경
                ]
            ))
        }
        return result
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                List {
                    topUserInfoView
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                    
                    ForEach(sections, id: \.stableID) { section in
                        Section {
                            ForEach(section.rows, id: \.stableID) { row in
                                rowView(row)
                            }
                            .listRowBackground(Color.gray50)
                        } header: {
                            headerView(section.header)
                                .listRowInsets(.init(top: 40, leading: 0, bottom: 8, trailing: 0)) // 리스트 Row랑 자동 정렬 맞추기
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
            .alert("로그아웃 하시겠어요?", isPresented: $showLogoutAlert) {
                Button("취소", role: .cancel) { }
                Button("로그아웃", role: .destructive) {
                    Task {
                        await viewModel.currentUserSignOut()
                    }
                }
            }
            .alert("정말로 탈퇴하시겠습니까?", isPresented: $showWithdrawAlert) {
                Button("취소", role: .cancel) { }
                Button("탈퇴", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAuth()
                        } catch {
                            print("erorr: \(error)")
                        }
                    }
                }
            } message: {
                Text("작성한 공고와 채팅 기록이 모두 삭제됩니다")
            }
        }
    }
    
    // MARK: - 탑) 유저 정보 입력 뷰
    private var topUserInfoView: some View {
        // 로그인 여부에 대한 분기 처리
        VStack(alignment: .leading) {
            if let user = auth.currentUser {
                Button {
                    
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(Font.pretendard(type: .semiBold, size: 24))
                            .foregroundStyle(Color.gray700)
                        Spacer().frame(height: 8)
                        Text("\(user.department)\n\(user.studentId)")
                            .font(Font.pretendard(type: .regular, size: 16))
                            .foregroundStyle(Color.gray600)
                            .lineSpacing(13.6)
                            .kerning(-0.16)
//                        Text(user.studentId)
//                            .font(Font.pretendard(type: .regular, size: 16))
//                            .foregroundStyle(Color.gray600)
//                            .lineSpacing(13.6)
//                            .kerning(-0.16)
                    }
                    .contentShape(Rectangle()) // 전체 폭 터치
                }
                .buttonStyle(.plain)// List에서 안전하게 동작
            } else {
                HStack(spacing: .zero) {
                    Text("로그인 해주세요")
                        .font(Font.pretendard(type: .semiBold, size: 24))
                        .foregroundStyle(Color.gray700)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.black)
                        .frame(width: 24, height: 24)
                }
                .contentShape(Rectangle()) // 전체 폭 터치
                .highPriorityGesture(
                    TapGesture().onEnded {
                        router.push(to: .startLoginView)
                    }
                )
            }
        }
    }
}


// MARK: - 리스트 header 아이템
@ViewBuilder
private func headerView(_ headerText: String) -> some View {
    if headerText == "" {
        EmptyView()
    } else {
        VStack {
            Text(headerText)
                .font(Font.pretendard(type: .semiBold, size: 18))
                .foregroundStyle(Color.gray700)
            Spacer().frame(height: 8)
        }
    }
}


// MARK: - 리스트 row 아이템
@ViewBuilder
private func rowView(_ row: MyPageRow) -> some View {
    switch row.kind {
    case .value(let title, let value):
        LabeledContent {
            Text(value)
                .font(.pretendard(type: .medium, size: 16))
                .foregroundStyle(Color.gray700)
        } label: {
            Text(title)
                .font(.pretendard(type: .medium, size: 16))
                .foregroundStyle(Color.gray700)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .contentShape(Rectangle())
    case .action(_, let title, let action):
        LabeledContent {
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.black)
                .frame(width: 24, height: 24)
        } label: {
            Text(title)
                .font(.pretendard(type: .medium, size: 16))
                .foregroundStyle(title == "회원 탈퇴" ? Color.accentRed : .gray700)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture().onEnded {
                action()
            }
        )
    }
}


#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(NavigationRouter())
            .environmentObject(FirebaseAuthManager.shared)
    }
}

