//
//  BlockHistoryViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import Foundation

@Observable
final class BlockHistoryViewModel {
    var blocks: [Block] = []
    var blockedUserNames: [String: String] = [:]
    var isLoading: Bool = false
    
    
    //MARK: - Block 데이터 불러오기
    @MainActor
    func loadBlockData() async {
        print("currentUser: \(FirebaseAuthManager.shared.currentUser?.userId ?? "없음")")
        isLoading = true
        defer { isLoading = false }
        
        guard let uid = FirebaseAuthManager.shared.currentUser?.userId, !uid.isEmpty else {
            print("currentUser 없음")
            return
        }
        
        do {
            print("rawValue: \(Block.CodingKeys.blockedUserId)")
            
            // 1) 내 blocks 불러오기 (최신순 정렬 원하면 orderBy 추가)
            let blocks: [Block] = try await FirestoreManager.shared.fetchAllFromSubcollection(
                under: .user,
                parentId: uid,
                subCollection: .blocks,
                orderBy: Block.CodingKeys.createdAt.rawValue,
                descending: true
            )
            
            // 2) block 문서의 documentID == blockedUserId 들만 추출
            let ids = Array(Set(blocks.map { $0.blockedUserId }))
            
            
            // 3) 병렬로 user 문서 조회 -> (id, User?)를 모아 딕셔너리로
            let usersMap: [String: User] = await withTaskGroup(of: (String, User?).self) { group in
                for id in ids {
                    group.addTask {
                        let user: User? = try? await FirestoreManager.shared.get(id, from: .user)
                        return (id, user)
                    }
                }
                var acc: [String: User] = [:]
                for await (id, user) in group {
                    if let user { acc[id] = user }
                }
                return acc
            }
            
            // 4) 상태 반영
            self.blocks = blocks
            self.blockedUserNames = usersMap.reduce(into: [:]) { dict, pair in
                dict[pair.key] = pair.value.name
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 신고 생성 테스트 버튼 로직 (삭제 예정)
    func createBlockTestButtonTapped() async {
        // 차단 유저 테스트
        let block = Block(blockedUserId: "FTMIffTVLdb8GuhHweHJEgAwFqB2")
        let _ = try? await FirestoreManager.shared.createSubCollection(
            block,
            id: FirebaseAuthManager.shared.currentUser?.userId ?? "",
            from: .user,
            fromSub: .blocks
        )
    }
    
    // MARK: - 차단 해제 (blocks에서 차단 유저 제거)
    func unblockUser(to blockedUserId: String) async {
        guard let uid = FirebaseAuthManager.shared.currentUser?.userId, !uid.isEmpty else {
            print("currentUser 없음")
            return
        }
        
        do {
            try await FirestoreManager.shared.deleteFromSubcollection(
                under: .user,
                parentId: uid,
                subCollection: .blocks,
                target: blockedUserId
            )
            
            if let idx = blocks.firstIndex(where: { $0.blockedUserId == blockedUserId }) {
                blocks.remove(at: idx)
            }
            blockedUserNames.removeValue(forKey: blockedUserId)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
}
