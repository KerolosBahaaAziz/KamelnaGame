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
        NavigationView {
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
                        List(viewModel.cups) { cup in
                            VStack(alignment: .leading) {
                                Text(cup.name)
                                    .font(.headline)
                                Text("Match type: \(cup.settings.matchType)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }

                    Button(action: {
                        showingCreateCup = true
                    }) {
                        Text("Create Cup")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .sheet(isPresented: $showingCreateCup) {
                    CreatePublicCup(viewModel: viewModel)
                }
                .onAppear {
                    viewModel.fetchCups()
                }
            }
        }
    }
}

#Preview {
    PublicCup()
}

