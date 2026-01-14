//
//  MockCarService.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

class MockCarService: CarServiceProtocol {

        func fetchMyCars() async throws -> [Car] {
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            
            return [
                Car(id: "1", brand: "Toyota", model: "Prius", year: 2017, vin: "JTDKN3DU123456", currentMileage: 145000, mileageUnit: .kilometers),
                Car(id: "2", brand: "BMW", model: "X5", year: 2020, vin: "WBA123456789", currentMileage: 45000, mileageUnit: .miles)
            ]
        }
    
    func fetchServiceHistory(for carId: String) async throws -> [ServiceItem] {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        // აქ შეგვიძლია გავფილტროთ ID-ის მიხედვით, მაგრამ მარტივად დავაბრუნოთ სია
        return [
            ServiceItem(id: "101", carId: carId, title: "ძრავის ზეთის შეცვლა", date: Date().addingTimeInterval(-86400 * 30), mileageAtService: 140000, cost: 120.0, notes: "Castrol 5W30", nextDueMileage: 148000, nextDueDate: nil),
            ServiceItem(id: "102", carId: carId, title: "სამუხრუჭე ხუნდები", date: Date().addingTimeInterval(-86400 * 120), mileageAtService: 135000, cost: 250.0, notes: "Brembo", nextDueMileage: nil, nextDueDate: nil)
        ]
    }
    
    func addCar(_ car: Car) async throws {
        // სიმულაცია წარმატებული დამატების
        try? await Task.sleep(nanoseconds: UInt64(0.5) * 1_000_000_000)
        print("Mock: მანქანა დაემატა - \(car.brand)")
    }
    
    func deleteCar(id: String) async throws {
        try? await Task.sleep(for: .seconds(0.5))
        print("Mock: მანქანა ID: \(id) წაიშალა.")
    }
}
