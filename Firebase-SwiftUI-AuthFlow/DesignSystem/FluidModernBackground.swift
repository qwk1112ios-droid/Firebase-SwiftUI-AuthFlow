//
//  FluidModernBackground.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 3/30/26.
//

import SwiftUI

struct FluidModernBackground: View {
    var body: some View {
        ZStack {
            
            // MARK: - Base Gradient (your palette)
            LinearGradient(
                colors: [
                    Color(hex: "#F5EDD8"),
                    Color(hex: "#E9E0F2"),
                    Color(hex: "#D5CBF0")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            // MARK: - Flowing Shape 1 (Top)
            FluidShape()
                .fill(.white.opacity(0.25))
                .blur(radius: 30)
                .scaleEffect(1.2)
                .offset(x: -120, y: -220)
            
            
            // MARK: - Ribbon Stroke (Modern Apple vibe)
            RibbonShape()
                .stroke(.white.opacity(0.35), lineWidth: 30)
                .blur(radius: 14)
                .offset(x: 80, y: -40)
                .rotationEffect(.degrees(-12))
            
            
            // MARK: - Secondary Ribbon (Soft purple tone)
            RibbonShape()
                .stroke(Color(hex: "#CFC3EE").opacity(0.6), lineWidth: 40)
                .blur(radius: 20)
                .offset(x: -100, y: 220)
                .rotationEffect(.degrees(18))
            
            
            // MARK: - Glass Card Glow (subtle depth)
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.35))
                .frame(width: 260, height: 180)
                .blur(radius: 2)
                .rotationEffect(.degrees(-8))
                .offset(x: 130, y: 260)
            
            
            // MARK: - Angular Accent (non-organic shape)
            AngularShape()
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.2),
                            Color(hex: "#F5EDD8").opacity(0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 300, height: 260)
                .blur(radius: 12)
                .offset(x: -150, y: 120)
        }
    }

}
// MARK: - Fluid Organic Shape (NOT a circle 👀)
struct FluidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.height * 0.3))
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.9, y: rect.height * 0.2),
            control1: CGPoint(x: rect.width * 0.3, y: rect.height * 0.0),
            control2: CGPoint(x: rect.width * 0.7, y: rect.height * 0.05)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.85, y: rect.height * 0.8),
            control1: CGPoint(x: rect.width * 1.1, y: rect.height * 0.3),
            control2: CGPoint(x: rect.width * 1.0, y: rect.height * 0.7)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.9),
            control1: CGPoint(x: rect.width * 0.7, y: rect.height * 1.1),
            control2: CGPoint(x: rect.width * 0.3, y: rect.height * 1.0)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.1, y: rect.height * 0.3),
            control1: CGPoint(x: rect.width * 0.0, y: rect.height * 0.8),
            control2: CGPoint(x: rect.width * 0.0, y: rect.height * 0.4)
        )
        
        return path
    }
}


// MARK: - Ribbon Shape (Modern curved line)
struct RibbonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.25, y: rect.midY - 100),
            control2: CGPoint(x: rect.width * 0.75, y: rect.midY + 100)
        )
        
        return path
    }
}


// MARK: - Angular Shape (for contrast)
struct AngularShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}


// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = (int >> 16) & 0xFF
        let g = (int >> 8) & 0xFF
        let b = int & 0xFF

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
#Preview {
    FluidModernBackground()
}
