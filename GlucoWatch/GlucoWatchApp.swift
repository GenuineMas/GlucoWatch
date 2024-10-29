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
            TabView {
                BarCodeView()
                    .tabItem {
                        Label("BarCode", systemImage: "barcode.viewfinder")
                    }
        
                BreadUnitsView()
                    .tabItem {
                        Label("XE", systemImage: "fork.knife")
                    }
                WatchSensor()
                    .tabItem {
                        Label("Sensor", systemImage: "applewatch.watchface")
                    }
                GlucoseDataView()
                    .tabItem {
                        Label("Glucose", systemImage: "diamond")
                    }
                ContentView()
                    .tabItem {
                        Label("ContentView", systemImage: "tag")
                    }
            }
        }
    }
}
