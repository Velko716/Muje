//
//  LoadingModifier.swift
//  Muje
//
//  Created by 조재훈 on 9/7/25.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
  let isLoading: Bool
  let message: String
  
  init(isLoading: Bool, message: String) {
    self.isLoading = isLoading
    self.message = message
  }
  
  func body(content: Content) -> some View {
    content
      .overlay {
        if isLoading {
          Color.black.opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .all)
            .overlay {
              VStack(spacing: 16) {
                ProgressView()
                  .scaleEffect(1.5)
                  .progressViewStyle(CircularProgressViewStyle())
                  .tint(.white)
                
                Text(message)
                  .font(.subheadline)
                  .foregroundStyle(.white)
              }
              .padding(.bottom, 50)
            }
            .background(Color.clear)
            .shadow(radius: 10)
        }
      }
      .disabled(isLoading)
      .animation(.easeInOut(duration: 0.2), value: isLoading)
  }
}

extension View {
  func loadingOverlay(
    _ isLoading: Bool,
    message: String
  ) -> some View {
    self.modifier(
      LoadingModifier(
        isLoading: isLoading,
        message: message
      )
    )
  }
}
