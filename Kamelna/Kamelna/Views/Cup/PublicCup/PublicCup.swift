//
//  PublicCup.swift
//  Kamelna
//
//  Created by Yasser Yasser on 20/05/2025.
//
import SwiftUI

struct PublicCup: View {
    @StateObject private var viewModel = CupViewModel()
    @State private var showingCreateCup = false
    
    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            
            VStack {
                if viewModel.cups.isEmpty {
                    VStack(spacing: 4) {
                        Image("PublicCup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                        
                        Text("لا يوجد دوريات عامة")
                            .font(.callout)
                            .foregroundStyle(Color.black)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.cups) { cup in
                                JoinPublicCupView(cup: cup)
                            }
                        }
                        .padding()
                    }
                }
                
                NavigationLink(destination: CreatePublicCup(viewModel: viewModel)) {
                    Text("Create Cup")
                        .frame(maxWidth : .infinity)
                        .padding()
                        .background(ButtonBackGroundColor.backgroundGradient)
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .onAppear {
                viewModel.fetchCups()
            }
        }
    }
}

#Preview {
    PublicCup()
}

