//
//  WatchSensor.swift
//  CalcXE
//
//  Created by Genuine on 27.10.2024.
//

import SwiftUI
import SensorKit

struct WatchSensor: View {
    
    @StateObject private var viewModel = SensorViewModel()
        
        var body: some View {
            VStack {
                Text("Sensor Authorization Example")
                    .font(.title)
                    .padding()
            }
            .onAppear {
                viewModel.requestAuthorization()
            }
        }
}


class SensorViewModel: NSObject, ObservableObject, SRSensorReaderDelegate {
    private let reader: SRSensorReader
    
    override init() {
        self.reader = SRSensorReader(sensor: .ambientLightSensor)
        super.init()
        self.reader.delegate = self
    }
    
    func requestAuthorization() {
        SRSensorReader.requestAuthorization(sensors: [.ambientLightSensor]) { error in
            if let error = error {
                print("Sensor authorization failed due to: \(error)")
            } else {
                print("User dismissed the authorization prompt. Awaiting authorization status changes.")
            }
        }
    }
    
    // SRSensorReaderDelegate methods
    func sensorReader(_ reader: SRSensorReader, didChangeAuthorizationStatus status: Bool) {
        if status {
            print("Authorized for ambient light sensor data.")
        } else {
            print("Denied or restricted access to ambient light sensor data.")
        }
    }
}


#Preview {
    WatchSensor()
}
