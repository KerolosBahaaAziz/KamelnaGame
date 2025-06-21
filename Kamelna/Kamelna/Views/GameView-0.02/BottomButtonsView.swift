//
//  BottomButtonsView.swift
//  Kamelna
//
//  Created by Yasser Yasser on 17/05/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct BottomButtonsView: View {
    @StateObject private var viewModel = BottomButtonsViewModel()
    
    var body: some View {
        Group {
            if viewModel.gameStatus == RoomStatus.waiting.rawValue {
                RoundTypeButtonsView(userName: "kero", status: "new")
            } else if viewModel.gameStatus == RoomStatus.started.rawValue {
                //ProjectsButtonsView()
                PointChoicesButtonsView()
            } else {
                Text("Unknown status: \(viewModel.gameStatus)")
            }
        }
        .animation(.easeInOut, value: viewModel.gameStatus)
        .transition(.opacity)
    }
    
    
}

#Preview {
    BottomButtonsView()
}
