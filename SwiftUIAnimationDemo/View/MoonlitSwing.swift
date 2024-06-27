//
//  MoonlitSwing.swift
//  HelloSwiftUI
//
//  Created by shiyanjun on 2024/6/27.
//

import SwiftUI

/// - 《月下秋千》
struct MoonlitSwing: View {
    @State private var swingOffset: CGSize = .zero
    @State private var swingDegrees: CGFloat = 30
    private let shadowRadius: CGFloat = 10
    private let textPadding: CGFloat = 10
    private let imageSize: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            VStack {
                titleView
                    .padding(.top, 30)
                    .padding(50)
                
                Spacer()
                
                swingImage(size: size)
                
                Spacer()
            }
        }
        .background(LinearGradient(colors: [.blue.opacity(0.2), .black.opacity(0.2)], startPoint: .topTrailing, endPoint: .bottomLeading))
    }
    
    @ViewBuilder
    private var titleView: some View {
        HStack(alignment: .top) {
            VStack {
                Group {
                    Text("月")
                    Text("下")
                    Text("秋")
                    Text("千")
                }
                .font(.system(.title, design: .rounded, weight: .light))
                .shadow(color: .white, radius: shadowRadius)
                .padding(.vertical, textPadding)
            }
            Spacer()
            
            Image(systemName: "moon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: imageSize)
                .rotationEffect(Angle(degrees: -90))
                .shadow(color: .white, radius: shadowRadius)
        }
    }
    
    @ViewBuilder
    private func swingImage(size: CGSize) -> some View {
        Image(systemName: "figure.climbing")
            .resizable()
            .foregroundColor(.white)
            .frame(width: imageSize, height: imageSize)
            .shadow(color: .white, radius: shadowRadius)
            .offset(swingOffset)
            .rotationEffect(Angle(degrees: swingDegrees))
            .onAppear {
                swingOffset = CGSize(width: 25 - size.width / 2, height: 0)
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    swingOffset = CGSize(width: size.width / 2 - 25, height: 0)
                    swingDegrees = -swingDegrees
                }
            }
    }
}

struct MoonlitSwing_Previews: PreviewProvider {
    static var previews: some View {
        MoonlitSwing()
            .preferredColorScheme(.dark)
    }
}
