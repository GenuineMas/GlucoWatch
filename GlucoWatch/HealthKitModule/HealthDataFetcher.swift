//
//  HealthDataFetcher.swift
//  CalcXE
//
//  Created by Genuine on 29.10.2024.
//

import Foundation
import HealthKit
import SwiftUI

class HealthDataFetcher: ObservableObject {
    private var healthStore = HKHealthStore()
    @Published var glucoseData: [HKQuantitySample] = []

    func requestAuthorization() {
        guard let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [glucoseType]) { success, error in
            if success {
                self.fetchGlucoseData()
            } else {
                print("Authorization failed")
            }
        }
    }

    func fetchGlucoseData() {
        guard let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            return
        }
        
        let query = HKSampleQuery(sampleType: glucoseType, predicate: nil, limit: 100, sortDescriptors: nil) { _, results, _ in
            guard let results = results as? [HKQuantitySample] else {
                return
            }
            DispatchQueue.main.async {
                self.glucoseData = results
            }
        }
        
        healthStore.execute(query)
    }
}
