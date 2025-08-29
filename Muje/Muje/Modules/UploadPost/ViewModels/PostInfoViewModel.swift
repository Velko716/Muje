//
//  PostInfoViewModel.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI
import PhotosUI

@Observable
final class PostInfoViewModel {
    var title: String = ""
    var organization: String = ""
    var content: String = ""
    var startDate = Date()
    var endDate: Date = Date()
    var endDateString: String = "마감일 선택"
    var isPicker: Bool = false
    var selectedItems: [PhotosPickerItem] = []
    var selectedImagesData: [Data] = []
    var showToast: Bool = false
    
    var dateRange: ClosedRange<Date> {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 365) //시작날짜 이후로 1년(365일 후)
        return min...max
    }
    
    
    func nextCheck() -> Bool {
        return (title.count < 5 || organization.count < 2 || content.count < 20 || startDate >= endDate)
    }
    
    func removeImage(at index: Int) {
        guard selectedImagesData.indices.contains(index), selectedItems.indices.contains(index) else {
            return
        }
        
        selectedImagesData.remove(at: index)
        selectedItems.remove(at: index)
    }
    
    func connectDate() {
        isPicker = false
        endDateString = endDate.dateString
    }
    
    func debug() {
        print("제목: \(title)")
        print("단체명: \(organization)")
        print("내용: \(content)")
        print("모집날짜: \(startDate.shortDateString)")
        print("종료 날짜: \(endDate.shortDateString)")
        print("종료 날짜 형식: \(endDateString)")
        print("시트: \(isPicker)")
        print("선택된 이미지 수: \(selectedItems.count)")
    }
}
