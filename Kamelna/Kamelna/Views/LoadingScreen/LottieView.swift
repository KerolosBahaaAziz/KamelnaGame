//
//  LottieView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop
    var speed: CGFloat = 1.0
    var color: UIColor? = nil
    var keypaths: [String] = ["**Fill 1.Color"] // Default keypath

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let animationView = LottieAnimationView()
        
        // Load animation
        animationView.animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        animationView.backgroundColor = .clear // 🔸 This line is key

        // Apply color before playing
        if let color = color {
            applyColor(to: animationView, color: color)
        }

        animationView.play()
        
        // Add constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    private func applyColor(to animationView: LottieAnimationView, color: UIColor) {
        let lottieColor = color.lottieColorValue
        keypaths.forEach { keypath in
            let keypath = AnimationKeypath(keypath: keypath)
            let colorProvider = ColorValueProvider(lottieColor)
            animationView.setValueProvider(colorProvider, keypath: keypath)
        }
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Re-apply color if it changes
        guard let animationView = uiView.subviews.first as? LottieAnimationView else { return }
        if let color = color {
            applyColor(to: animationView, color: color)
        }
    }
}

#Preview {
    LottieView(animationName: "Loading", color: UIColor(red: 239/255, green: 169/255, blue: 74/255, alpha: 1))
}

extension UIColor {
    var lottieColorValue: LottieColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return LottieColor(
            r: Double(red),
            g: Double(green),
            b: Double(blue),
            a: Double(alpha)
        )
    }
}
