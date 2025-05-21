//
//  GoogleButton.swift
//  RFOXIA
//
//  Created by Yasser Yasser on 22/04/2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth

struct GoogleButton: View {
    var action : () -> Void
    var body: some View {
        GoogleSignInButton(scheme: .light,
                           style: .standard,
                           state: .normal, action: {
            action()
        })
        .padding([.leading, .trailing] , 50)
    }
}

#Preview {
    GoogleButton(action: {})
}
