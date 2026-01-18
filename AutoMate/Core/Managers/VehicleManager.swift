//
//  VehicleManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import Combine
import SwiftUI

class VehicleManager: ObservableObject {
    static let shared = VehicleManager()
    
    @Published var cars: [MyCar] = [] {
        didSet { saveToStorage() }
    }
    
    init() { loadFromStorage() }
    
    func addCar(_ car: MyCar) {
        cars.append(car)
    }
    
    func removeCar(at offsets: IndexSet) {
        cars.remove(atOffsets: offsets)
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(cars) {
            UserDefaults.standard.set(encoded, forKey: "automate_v5")
        }
    }
    
    private func loadFromStorage() {
        // VehicleManager.swift-ში შეცვალე სატესტო ნაწილი:
        if let data = UserDefaults.standard.data(forKey: "automate_v5"),
           let decoded = try? JSONDecoder().decode([MyCar].self, from: data) {
            self.cars = decoded
        } else {
            self.cars = [
                MyCar(make: "BMW", model: "M5 F90", year: "2021", engine: "4.4 V8", vinCode: "WBSJF0000TEST123"),
                MyCar(make: "Porsche", model: "911 Carrera", year: "2023", engine: "3.0 H6", vinCode: "WP0ZZZ99TEST456") // ✅ მეორე მანქანა
            ]
        }
    }
}
