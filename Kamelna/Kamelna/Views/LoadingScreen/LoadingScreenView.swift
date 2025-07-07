//
//  LoadingScreenView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import SwiftUI
import Lottie

struct LoadingScreenView: View {
    @State private var timeRemaining = 60
    @State private var timer: Timer? = nil
    var loadingText = "Waiting for Other Players To Join ..."
    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient
                .ignoresSafeArea()

            VStack {
                LogoView(width: 300,height: 300)
                Text(loadingText)
                    .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                    .font(.title2)
                    .padding()
                LottieView(
                    animationName: "TestLoading",
                    color: UIColor(red: 239/255, green: 169/255, blue: 74/255, alpha: 1),
                    keypaths: [ "**Fill 1.Color", "**.Background.Fill 1.Color"]
                )
                .frame(width: 300, height: 300)

                Text("\(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
//                    .padding(.top, 20)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}

#Preview {
    LoadingScreenView()
}

