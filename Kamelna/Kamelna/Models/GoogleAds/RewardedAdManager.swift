//
//  SwiftUIView.swift
//  Kamelna
//
//  Created by Kerlos on 13/05/2025.
//

import GoogleMobileAds
import SwiftUI

import GoogleMobileAds

class RewardedAdManager: NSObject, FullScreenContentDelegate {
    static let shared = RewardedAdManager()

    private var rewardedAd: RewardedAd?
    private var rewardCallback: (() -> Void)?
    @Published var isAdReady: Bool = false

    func loadAd() {
        let request = Request()
        RewardedAd.load(
            with: "ca-app-pub-3940256099942544/1712485313", // Test unit
            request: request
        ) { ad, error in
            if let error = error {
                print("Failed to load ad: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.isAdReady = true
        }
    }

    func showAd(from root: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewardedAd else {
            print("Ad not ready")
            return
        }
        rewardCallback = onReward
        ad.present(from: root) {
            let reward = ad.adReward
            print("User rewarded with \(reward.amount) \(reward.type)")
            self.rewardCallback?()
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        loadAd() // Reload for next time
    }
    
}
