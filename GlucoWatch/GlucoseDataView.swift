//
//  GlucoseDataView.swift
//  GlucoWatch
//
//  Created by Genuine on 29.10.2024.
//

import SwiftUI
import HealthKit

struct GlucoseDataView: View {
    @ObservedObject var healthDataFetcher = HealthDataFetcher()
    
    var body: some View {
        VStack {
            Text("Blood Glucose Levels")
                .font(.title)
                .padding()
            
            if healthDataFetcher.glucoseData.isEmpty {
                Text("No data available")
                    .foregroundColor(.gray)
            } else {
                // Graph representation
                GraphView(glucoseData: healthDataFetcher.glucoseData)
                    .frame(height: 200)
                    .padding()

                // List of glucose data
                List(healthDataFetcher.glucoseData, id: \.uuid) { sample in
                    HStack {
                        Text("Glucose Level:")
                        Spacer()
                        Text("\(sample.quantity.doubleValue(for: HKUnit(from: "mg/dL")))")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            healthDataFetcher.requestAuthorization()
        }
    }
}

struct GraphView: View {
    var glucoseData: [HKQuantitySample]

    var body: some View {
        GeometryReader { geometry in
            let maxGlucose = glucoseData.map { $0.quantity.doubleValue(for: HKUnit(from: "mg/dL")) }.max() ?? 1
            let minGlucose = glucoseData.map { $0.quantity.doubleValue(for: HKUnit(from: "mg/dL")) }.min() ?? 0

            Path { path in
                for (index, sample) in glucoseData.enumerated() {
                    let x = CGFloat(index) / CGFloat(glucoseData.count) * geometry.size.width
                    let y = geometry.size.height - CGFloat((sample.quantity.doubleValue(for: HKUnit(from: "mg/dL")) - minGlucose) / (maxGlucose - minGlucose)) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}

#Preview {
    GlucoseDataView()
}
