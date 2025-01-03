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
    init() {
           // Load Frida Gadget dynamically at the start of the app
           loadFridaGadget()
      
       }

    var body: some Scene {
        WindowGroup {
            TabView {
//                BarCodeView()
//                    .tabItem {
//                        Label("BarCode", systemImage: "barcode.viewfinder")
//                    }
                
                
        
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
    private func loadFridaGadget() {
           let gadgetPath = Bundle.main.path(forResource: "frida-gadget", ofType: "dylib")
           
           // Load the gadget using dlopen
        if dlopen(gadgetPath, RTLD_NOW) != nil {
               print("Frida Gadget loaded successfully.")
           } else {
               print("Failed to load Frida Gadget: \(String(cString: dlerror()))")
           }
       }

}
