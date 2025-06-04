//
//  MiniProfileView.swift
//  Kamelna
//
//  Created by Andrew Emad Morris on 26/05/2025.
//

import SwiftUI

struct MiniProfileView : View {
   
    @Binding var showMiniProfile : Bool
    @ObservedObject var profileViewModel = ProfileViewModel()
    var body: some View {
        VStack{
          Text("hello")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SecondaryBackgroundGradient.backgroundGradient)
    }
}

#Preview {
    MiniProfileView(showMiniProfile: .constant(false))
}
