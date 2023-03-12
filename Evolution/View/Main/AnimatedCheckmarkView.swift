//
//  AnimatedCheckmarkView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI

struct AnimatedCheckmarkView: View {
    var size: CGSize = .init(width: 35, height: 35)
    var innerShapeSizeRatio: CGFloat = 1/2.5
    private var animationDuration: Double = 0.75
    @State private var outerTrimEnd: CGFloat = 0
    @State private var innerTrimEnd: CGFloat = 0
    @State private var scale = 1.0
    @State private var strokeColor = Color.blue
    private var strokeStyle: StrokeStyle = .init(lineWidth: 3, lineCap: .round, lineJoin: .round)
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: outerTrimEnd)
                .stroke(strokeColor, style:strokeStyle)
                .rotationEffect(.degrees(-90))
       
            Checkmark()
                .trim(from: 0, to: innerTrimEnd)
                .stroke(strokeColor, style:strokeStyle)
                .frame(width: size.width * innerShapeSizeRatio, height: size.height * innerShapeSizeRatio)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(scale)
        .onAppear() {
            animate()
        }
        
    }
    func animate() {
        withAnimation(.linear(duration: 0.4 * animationDuration)) {
            outerTrimEnd = 1.0
        }
        
        withAnimation(
            .linear(duration: 0.3 * animationDuration)
            .delay(0.4 * animationDuration)
        ) {
            innerTrimEnd = 1.0
        }
        
        withAnimation(
            .linear(duration: 0.2 * animationDuration)
            .delay(0.7 * animationDuration)
        ) {
            strokeColor = .green
            scale = 1.1
            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
            impactHeavy.impactOccurred()
        }
        
        withAnimation(
            .linear(duration: 0.1 * animationDuration)
            .delay(0.9 * animationDuration)
        ) {
            scale = 1
        }
    }
}

struct AnimatedCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCheckmarkView()
    }
}
struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        
        var path = Path()
        path.move(to: .init(x: 0 * width, y: 0.5 * height))
        path.addLine(to: .init(x: 0.4 * width, y: 1.0 * height))
        path.addLine(to: .init(x: 1.0 * width, y: 0 * height))
        return path
    }
}
