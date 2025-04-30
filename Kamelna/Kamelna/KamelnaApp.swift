//
//  KamelnaApp.swift
//  Kamelna
//
//  Created by Yasser Yasser on 28/04/2025.
//

import SwiftUI

@main
struct KamelnaApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
