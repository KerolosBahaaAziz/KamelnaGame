//
//  ApplePayView.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import SwiftUI

struct ApplePayView: View {
    var applePayHandler = ApplePayHandler()
    var body: some View {
        ApplePayButton {
            applePayHandler.startApplePay{ success in
                if success {
                    print("Payment Successful ✅")
                } else {
                    print("Payment Failed ❌")
                }
            }
        }

    }
}

#Preview {
    ApplePayView()
}
