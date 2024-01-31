//
//  ContentView.swift
//  HealthKITSwift
//
//  Created by Haadhya on 20/12/23.
//

import SwiftUI
import HealthKit
#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            Button("Request HealthKit Authorization") {
                healthKitManager.requestAuthorization()
            }
            Button("Fetch Recent Workout") {
                healthKitManager.fetchRecentWorkout()
            }
        }
    }
}

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()

    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                print("HealthKit authorization granted")
            } else {
                print("HealthKit authorization denied. Error: \(error?.localizedDescription ?? "")")
            }
        }
    }

    func fetchRecentWorkout() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }

        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let workout = samples?.first as? HKWorkout {
                print("Workout Type: \(workout.workoutActivityType.rawValue)")
                print("Start Date: \(workout.startDate)")
                print("End Date: \(workout.endDate)")
                print("Duration: \(workout.duration)")
            } else {
                print("No workouts found. Error: \(error?.localizedDescription ?? "")")
            }
        }

        healthStore.execute(query)
    }
}










//struct ContentView: View {
//    @State private var heartRate: Double?
//
//    var body: some View {
//        VStack {
//            Text("Heart Rate: \(heartRate ?? 0)")
//                .onAppear {
//                    requestHealthKitAuthorization()
//                    queryHeartRateData()
//                }
//        }
//    }
//}
//
//func queryHeartRateData() {
//    guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
//        return
//    }
//
//    let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 100, sortDescriptors: nil) { (query, results, error) in
//        if let samples = results as? [HKQuantitySample] {
//            for sample in samples {
//                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
//                print("Heart Rate: \(heartRate)")
//            }
//        }
//    }
//
//    HKHealthStore().execute(query)
//}
//func requestHealthKitAuthorization() {
//    let healthStore = HKHealthStore()
//
//    let dataTypesToRead: Set<HKObjectType> = [
//        HKObjectType.quantityType(forIdentifier: .heartRate)!,
//        // Add other data types you want to read here
//    ]
//
//    healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead) { (success, error) in
//        if success {
//            // Authorization granted, you can now access HealthKit data
//        } else {
//            // Handle error
//            if let error = error {
//                print("HealthKit Authorization Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
