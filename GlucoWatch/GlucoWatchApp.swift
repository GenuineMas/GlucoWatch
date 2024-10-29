//
//  GlucoWatchApp.swift
//  GlucoWatch
//
//  Created by Genuine on 29.10.2024.
//

import SwiftUI

@main
struct GlucoWatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
