//
//  ApplePayButton.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import SwiftUI
import PassKit

struct ApplePayButton: View {
    
    var action : () -> Void
    
    var body: some View {
        Representable(action: action)
            .frame(minWidth: 100 , maxWidth: 400)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
    }
}

#Preview {
    ApplePayButton(action: {})
}

extension ApplePayButton {
    struct Representable : UIViewRepresentable {
        var action : () -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(action : action)
        }
        
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.button
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.action = action
        }
    }
    
    class Coordinator : NSObject {
        var action : () -> Void
        
        var button =  PKPaymentButton(paymentButtonType: .subscribe,
                                      paymentButtonStyle: .automatic)
        
        init(action : @escaping () -> Void){
            self.action = action
            super.init()
            button.addTarget(self,
                             action: #selector(callBack(_:)),
                             for: .touchUpInside)
        }
        
        @objc func callBack(_ sender : Any){
            action()
        }
    }
}
