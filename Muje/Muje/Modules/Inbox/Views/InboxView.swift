//
//  InboxView.swift
//  Muje
//
//  Created by 김진혁 on 8/14/25.
//

import SwiftUI

struct InboxView: View {
    @State private var viewModel: InboxViewModel = .init()
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    private let buttonSize: CGFloat = 40 // SendButton 버튼 사이즈 비교
    
    private var sendEnabled: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                topCurrentPostView
                Divider()
                Spacer()
                middleInboxContentView
            }
            .paddingH16()
        }
        .safeAreaInset(edge: .bottom) {
            bottomInboxInputBar
        }
        .toolbar {
            navigationToolbarItems
        }
    }
    
    // MARK: - 네비게이션 툴 바 아이템
    @ToolbarContentBuilder
    private var navigationToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                // TODO: 뒤로가기 수행
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 8) {
                Text("\(String(describing: FirebaseAuthManager.shared.currentUser?.name))")
                InboxNavigationChip(type: .applicant) // FIXME: - 쪽지 타입을 Post Firebase에서 불러오게끔 변경해야함. (임시뷰)
                    .frame(width: 61)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // TODO: 액션 시트 나오기
            } label: {
                Image(.ellipsisVertical)
            }
        }
    }
    
    // MARK: - 탑 현재 공고 뷰
    private var topCurrentPostView: some View {
        VStack(spacing: .zero) {
            InboxCurrentPostView(title: "댄스월드 연합 댄스 동아리💃 춤도 추고 친목도 다질 사람 모여라🙌") // FIXME: - 공고 타이틀로 수정
                .padding(.vertical, 20)
        }
    }
    
    // MARK: - 중간 쪽지 내용 뷰
    private var middleInboxContentView: some View {
        VStack {
            
        }
    }
    
    // MARK: - 바텀 쪽지 텍스트 필드 입력창
    private var bottomInboxInputBar: some View {
        VStack(spacing: 10) {
            Divider()
            ZStack(alignment: .trailing) {
                VStack(spacing: 0) {
                    TextField("메세지를 입력하세요", text: $text, axis: .vertical)
                        .focused($isFocused)
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                        .lineLimit(1...5)
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                        .padding(.trailing, buttonSize + 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .stroke(.secondary.opacity(0.12), lineWidth: 1)
                )
                .frame(minHeight: 44)
                
                InboxSendButton(sendEnabled: sendEnabled) { self.text = viewModel.send(text: text)
                }
                    .frame(width: buttonSize, height: buttonSize)
                    .padding(.trailing, 8)
                    .disabled(!sendEnabled)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .animation(.easeInOut(duration: 0.15), value: text)
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}
