//
//  PrivateCup.swift
//  Kamelna
//
//  Created by Yasser Yasser on 01/07/2025.
//

import SwiftUI

struct PrivateCup: View {
    @StateObject private var viewModel = PrivateCupViewModel()
    @State private var showingCreateCup = false
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        ZStack {
            BackgroundGradient.backgroundGradient.ignoresSafeArea()
            
            VStack {
                if !userViewModel.isLoading && !viewModel.isLoading {
                    if viewModel.cups.isEmpty {
                        VStack(spacing: 4) {
                            Image("PrivateCup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                            Text("لا يوجد دوريات خاصة")
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
                                    JoinPrivateCupView(cup: cup)
                                }
                            }
                            .padding()
                        }
                    }
                }else {
                    ProgressView("جاري تحميل البيانات...")
                        .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                }
                
                NavigationLink(destination: CreatePrivateCup(viewModel: viewModel)) {
                    Text("إنشاء دوري خاص")
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
                //                guard let user = userViewModel.user else {
                //                    print("⚠️ User not loaded yet.")
                //                    return
                //                }
                //                
                //                var allCupIDs = Set(user.cupIdList)
                //
                //                for friend in userViewModel.friendList {
                //                    allCupIDs.formUnion(friend.cupIdList)
                //                }
                //
                //                print("📥 Fetching Cups:", allCupIDs)
                //
                //                for id in allCupIDs {
                //                    viewModel.fetchCup(cupID: id)
                //                }
            }
            .onChange(of: userViewModel.isLoading){
                if !userViewModel.isLoading {
                    guard let user = userViewModel.user else {
                        print("⚠️ User not loaded yet.")
                        return
                    }
                    var allCupIDs = Set(user.cupIdList)
                    
                    for friend in userViewModel.friendList {
                        allCupIDs.formUnion(friend.cupIdList)
                    }
                    
                    print("📥 Fetching Cups:", allCupIDs)
                    
                    for id in allCupIDs {
                        viewModel.fetchCup(cupID: id)
                    }
                }
            }
            
            .onDisappear{
                viewModel.stopListeningToCups()
            }
        }
    }
}

#Preview {
    PrivateCup()
}

