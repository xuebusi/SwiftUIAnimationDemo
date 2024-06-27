//
//  ImageCarousel.swift
//  SwiftUIAnimationDemo
//
//  Created by shiyanjun on 2024/6/28.
//

import SwiftUI

/// - 《风雪云雨晴》
struct ImageCarousel: View {
    @State private var currentIndex: Int = 0
    @State private var offset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    struct Weather: Identifiable {
        var id: UUID = .init()
        var symbol: String
        var message: String
    }
    
    let images: [Weather] = [
        .init(symbol: "wind", message: "风"),
        .init(symbol: "snowflake", message: "雪"),
        .init(symbol: "cloud.fill", message: "云"),
        .init(symbol: "cloud.rain.fill", message: "雨"),
        .init(symbol: "sun.max.fill", message: "晴"),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                ForEach((0..<images.count).reversed(), id: \.self) { index in
                    if index >= currentIndex {
                        VStack {
                            Image(systemName: images[index].symbol)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 180, height: 180)
                            Text("\(images[index].message)")
                                .font(.system(.headline))
                        }
                        .clipped()
                        .offset(y: index == currentIndex ? offset.height : size.height)
                        .scaleEffect(index == currentIndex ? 1 : 0.8)
                        .opacity(index == currentIndex ? 1 : 0)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if index == currentIndex {
                                        offset = gesture.translation
                                        isDragging = true
                                    }
                                }
                                .onEnded { _ in
                                    handleDragEnd(size: size)
                                    isDragging = false
                                }
                        )
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .overlay(alignment: .bottom) {
                controlButtons(size: size)
                    .frame(height: 100)
            }
        }
        .ignoresSafeArea()
    }
    
    // 处理拖动结束的逻辑
    private func handleDragEnd(size: CGSize) {
        if offset.height < -size.height / 6 {
            // 向上滑动超过屏幕的1/6
            animateOffset(to: CGSize(width: 0, height: -size.height)) {
                offset = CGSize(width: 0, height: size.height)
                currentIndex = (currentIndex + 1) % images.count
                withAnimation { offset = .zero }
            }
        } else if offset.height > size.height / 6 {
            // 向下滑动超过屏幕的1/6
            animateOffset(to: CGSize(width: 0, height: size.height)) {
                offset = CGSize(width: 0, height: -size.height)
                currentIndex = (currentIndex - 1 + images.count) % images.count
                withAnimation { offset = .zero }
            }
        } else {
            // 没有超过屏幕的1/6，恢复原位
            withAnimation { offset = .zero }
        }
    }
    
    // 动画封装
    private func animateOffset(to newOffset: CGSize, completion: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = newOffset
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: completion)
    }
    
    // 控制按钮视图
    private func controlButtons(size: CGSize) -> some View {
        HStack(spacing: 30) {
            Button("上一个") {
                animateOffset(to: CGSize(width: 0, height: size.height)) {
                    offset = CGSize(width: 0, height: -size.height)
                    currentIndex = (currentIndex - 1 + images.count) % images.count
                    withAnimation { offset = .zero }
                }
            }
            .buttonStyle(.bordered)
            .tint(.white)
            
            Button("下一个") {
                animateOffset(to: CGSize(width: 0, height: -size.height)) {
                    offset = CGSize(width: 0, height: size.height)
                    currentIndex = (currentIndex + 1) % images.count
                    withAnimation { offset = .zero }
                }
            }
            .buttonStyle(.bordered)
            .tint(.white)
        }
    }
}

#Preview {
    ImageCarousel()
        .preferredColorScheme(.dark)
}
