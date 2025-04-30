//
//  GoogleSignInView.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import SwiftUI


struct GoogleSignInView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GoogleButton {
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                GoogleAuthHandler.shared.signIn(presenting: rootVC) { success in if success {
                        // Dismiss or show success UI
                    }
                }
            }
        }
    }
}

#Preview {
    GoogleSignInView()
}
