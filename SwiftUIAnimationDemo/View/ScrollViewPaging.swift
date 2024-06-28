//
//  ScrollViewPaging.swift
//  SwiftUIAnimationDemo
//
//  Created by shiyanjun on 2024/6/28.
//

import SwiftUI

/// - ScrollView实现水平分页滚动和垂直分页滚动
struct ScrollViewPaging: View {
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var axes: Axis.Set = .vertical
    
    struct ImageCard: Identifiable {
        var id = UUID().uuidString
        var symbol: String
        var color: Color = .white
    }
    
    let cards: [ImageCard] = [
        ImageCard(symbol: "sun.max.fill", color: .yellow),
        ImageCard(symbol: "cloud.drizzle.fill", color: .cyan),
        ImageCard(symbol: "cloud.sun.fill", color: .purple),
        ImageCard(symbol: "smoke.fill", color: .green),
        ImageCard(symbol: "wind", color: .pink),
    ]
    
    var body: some View {
        ScrollView(axes, showsIndicators: false) {
            VStack(spacing: 0) {
                if axes == .vertical {
                    VStack(spacing: 0) {
                        ForEach(cards.indices, id: \.self) { index in
                            VStack {
                                Image(systemName: cards[index].symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                            .id(index)
                            .frame(width: screenWidth, height: screenHeight)
                            .background(cards[index].color.opacity(0.3))
                        }
                    }
                } else if axes == .horizontal {
                    HStack(spacing: 0) {
                        ForEach(cards.indices, id: \.self) { index in
                            VStack {
                                Image(systemName: cards[index].symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                            .id(index)
                            .frame(width: screenWidth, height: screenHeight)
                            .background(cards[index].color.opacity(0.3))
                        }
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .overlay(alignment: .bottom) {
            HStack {
                Button("垂直滚动") {
                    axes = .vertical
                }
                .buttonStyle(.bordered)
                .tint(axes == .vertical ? .gray : .white)
                
                Button("水平滚动") {
                    axes = .horizontal
                }
                .buttonStyle(.bordered)
                .tint(axes == .horizontal ? .gray : .white)
            }
            .frame(height: 200)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScrollViewPaging()
        .preferredColorScheme(.dark)
}
