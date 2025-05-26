//
//  KamelnaApp.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI
import GoogleMobileAds

@main
struct KamelnaApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegat

    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
