//
//  InfoBox.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct InfoBox: View {
    var image: Data?
    var name: String
    var title: String
    
    var body: some View {
        HStack(spacing: 8) {
            if let data = image {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 54, height: 54)
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(width: 54, height: 54)
            }
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundStyle(Color.gray)
                Text(title)
                    .font(.title3)
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
        }
    }
}

#Preview {
    InfoBox(name: "동아리명", title: "댄스 동아리 OO 모집합니다")
}
