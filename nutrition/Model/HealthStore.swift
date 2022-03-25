import Foundation
import HealthKit

struct HealthStore {

    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }

    static func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {

        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }

        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let bodyFatPercentage = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage),
              let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }

        let typesToWrite = Set([ activeEnergy ])
        let typesToRead = Set([ dateOfBirth,
                                bodyMass,
                                bodyFatPercentage,
                                activeEnergy ])

        HKHealthStore().requestAuthorization(toShare: typesToWrite,
                                             read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }

    // func getAge() -> Int {

    //     var age = 0
    //     do {
    //         let healthStore = HKHealthStore()
    //         let birthdayComponents = try healthStore.dateOfBirthComponents()

    //         let today = Date()
    //         let calendar = Calendar.current
    //         let todayDateComponents = calendar.dateComponents([.year], from: today)
    //         let thisYear = todayDateComponents.year!
    //         age = thisYear - birthdayComponents.year!
    //         print("age: " + String(age))
    //     } catch {
    //         print("Error info: \(error)")
    //     }
    //     return age
    // }

    static func getMostRecentSample(sampleType: HKSampleType,
                                    startDate: Date = Date.distantPast,
                                    endDate: Date = Date(),
                                    completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        print("Start date: \(formatter.string(from: startDate))")
        print("End   date: \(formatter.string(from: endDate))")

        // 1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in

            // 2. Always dispatch to the main thread when complete
            DispatchQueue.main.async {
                guard let samples = samples,
                      let sample = samples.first as? HKQuantitySample else {
                    completion(nil, error)
                    return
                }
                completion(sample, nil)
            }
        }

        HKHealthStore().execute(sampleQuery)
    }
}
