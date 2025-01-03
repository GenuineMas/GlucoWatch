//
//  WatchSensor.swift
//  CalcXE
//
//  Created by Genuine on 27.10.2024.
//

//import SwiftUI
//import SensorKit
//import ObjectiveC.runtime
//
//struct WatchSensor: View {
//    
//    @StateObject private var viewModel = SensorViewModel()
//        
//        var body: some View {
//            VStack {
//                Text("Sensor Authorization Example")
//                    .font(.title)
//                    .padding()
//            }
//            .onAppear {
//    
//                viewModel.requestAuthorization()
//               
//            }
//        }
//}
//
//
//class SensorViewModel: NSObject, ObservableObject, SRSensorReaderDelegate {
//    private let reader: SRSensorReader
//    
//    override init() {
//        self.reader = SRSensorReader(sensor: .photoplethysmogram)
//        super.init()
//        self.reader.delegate = self
//    }
//    
//    
//    func requestAuthorization() {
//    
//            SRSensorReader.requestAuthorization(sensors: [.photoplethysmogram]) { error in
//                if let error = error {
//                    print("Sensor authorization failed due to: \(error)")
//                } else {
//                    print("User dismissed the authorization prompt. Awaiting authorization status changes.")
//                }
//            }
//
//    }
//    
//    // SRSensorReaderDelegate methods
//    func sensorReader(_ reader: SRSensorReader, didChangeAuthorizationStatus status: Bool) {
//        if status {
//            print("Authorized for PPG light sensor data.")
//        } else {
//            print("Denied or restricted access to ambient light sensor data.")
//        }
//    }
//}





//func loadSensorKit() {
//    let frameworkPath = "/System/Library/PrivateFrameworks/SensorKit.framework"
//    if let bundle = Bundle(path: frameworkPath) {
//        do {
//            try bundle.load()
//            print("SensorKit framework loaded successfully!")
//        } catch {
//            print("Failed to load SensorKit framework: \(error)")
//        }
//    }
//    // Access a private class dynamically
//    if let sensorManagerClass = NSClassFromString("SRSensorReader") as? NSObject.Type {
//        let sensorManager = sensorManagerClass.init()
//
//        // Call a private method
//        let selector = NSSelectorFromString("requestAuthorization(sensors: [.photoplethysmogram]):")
//        if sensorManager.responds(to: selector) {
//            let block: @convention(block) (Bool) -> Void = { success in
//                print("Authorization success: \(success)")
//            }
//            let implementation = imp_implementationWithBlock(block)
//            let completionHandler = unsafeBitCast(implementation, to: AnyObject.self)
//
//            sensorManager.perform(selector, with: completionHandler)
//        } else {
//            print("Method not found or inaccessible")
//        }
//    }
//}

//
//
//#Preview {
//    WatchSensor()
//}

import SwiftUI
import Foundation
import ObjectiveC.runtime

struct WatchSensor: View {
    @StateObject private var viewModel = SensorViewModel()

    var body: some View {
        VStack {
            Text("Sensor Authorization Example")
                .font(.title)
                .padding()
        }
        .onAppear {
            loadSensorKit()
            let api = SensorKitAPI()
                  api.initializeSensorKit()
                  api.initializeSensorReader()

           // viewModel.requestAuthorization()
        }
    }
}

class SensorViewModel: NSObject, ObservableObject {
    private var reader: AnyObject?

    override init() {
        super.init()
        loadSensorKit()
        inspectMethodsForClass("SRSensorReader")
//        setupReader()
    }
    
    // Function to inspect methods of a class dynamically
    func inspectMethodsForClass(_ className: String) {
        // Load SensorKit framework
         let bundle = loadSensorKit()
        
        // Dynamically access the class
        guard let sensorReaderClass = NSClassFromString(className) else {
            print("Class \(className) not found.")
            return
        }
        
        // Use the runtime to get a list of methods for the class
        var methodCount: UInt32 = 0
        let methodList = class_copyMethodList(sensorReaderClass, &methodCount)
        
        // Print out all methods for the class
        for i in 0..<Int(methodCount) {
            let method = methodList?[i]
            let selector = method_getName(method!)
            print("Method: \(NSStringFromSelector(selector))")
        }
        
        free(methodList)  // Free memory after inspection
    }

    // Test to inspect available methods for SRSensorReader
   

    private func setupReader() {
        // Dynamically create the sensor reader for photoplethysmogram
        guard let sensorReaderClass = NSClassFromString("SRSensorReader") as? NSObject.Type else {
            print("SRSensorReader class not found")
            return
        }

        let initSelector = Selector("initWithSensor:")
        guard sensorReaderClass.instancesRespond(to: initSelector) else {
            print("initWithSensor: selector not found")
            return
        }

        // Dynamically call the initializer
        let sensorType = NSClassFromString("SRSensor.SRSensorPhotoplethysmogram")
        let readerInstance = sensorReaderClass.perform(initSelector, with: sensorType)?.takeUnretainedValue()
        
        self.reader = readerInstance
    }

    func requestAuthorization() {
        guard let readerClass = NSClassFromString("SRSensorReader") as? NSObject.Type else {
            print("SRSensorReader class not found")
            return
        }

        let selector = Selector("requestAuthorizationForSensors:completion:")
        guard readerClass.responds(to: selector) else {
            print("requestAuthorizationForSensors:completion: selector not found")
            return
        }

        // Define a completion block
        let completion: @convention(block) (Error?) -> Void = { error in
            if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            } else {
                print("Authorization request completed.")
            }
        }

        let block = unsafeBitCast(completion, to: AnyObject.self)

        // Dynamically invoke the method with the block
        let sensors = ["SRSensor.photoplethysmogram"]
        readerClass.perform(selector, with: sensors, with: block)
    }
}

func loadSensorKit() {
    let frameworkPath = "/System/Library/PrivateFrameworks/SensorKit.framework"
    if let bundle = Bundle(path: frameworkPath) {
        do {
            try bundle.load()
            print("SensorKit framework loaded successfully!")
        } catch {
            print("Failed to load SensorKit framework: \(error)")
        }
    }
}


