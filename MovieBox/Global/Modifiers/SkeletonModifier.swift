//
//  SkeletonModifier.swift
//  MovieBox
//
//  Created by shinisac on 8/8/25.
//

import SwiftUI

struct SkeletonModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    @Binding var isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay {
                    Rectangle()
                        .fill(LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.white.opacity(0.1), .clear]),
                                startPoint: .leading,
                                endPoint: .trailing))
                        .rotationEffect(.degrees(0)) // 기울기 0도로 고정
                        .frame(width: 200) // 충분히 넓게 설정
                        .offset(x: phase * 350)
                }
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}

#Preview(body: {
    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/8UlWHdLMpgZm9bx6QYh0NFoq67TZ.jpg"))
        .frame(height: 350)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        .modifier(SkeletonModifier(isActive: .constant(true)))
})
