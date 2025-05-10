//
//  LogoView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 06/05/2025.
//

import SwiftUI

struct LogoView: View {
    @State var width : CGFloat = 100
    @State var height : CGFloat = 100
    var body: some View {
        Image(.logo)
            .resizable()
            .frame(width: width,height: height)
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    LogoView()
}
