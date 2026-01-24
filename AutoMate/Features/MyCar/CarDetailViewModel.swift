//
//  CarDetailViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class CarDetailViewModel: ObservableObject {
    @Published var services: [ServiceRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // ვიყენებთ რეალურ მენეჯერს
    private let vehicleManager = VehicleManager.shared
    private let carId: String
    
    init(carId: String) {
        self.carId = carId
        // საწყისი ჩატვირთვა
        loadServices()
    }
    
    func loadServices() {
        // მოვძებნოთ კონკრეტული მანქანა მენეჯერში და წამოვიღოთ მისი სერვისები
        if let car = vehicleManager.cars.first(where: { $0.id == carId }) {
            self.services = (car.services ?? []).sorted(by: { $0.date > $1.date })
        } else {
            self.errorMessage = "მანქანა ვერ მოიძებნა"
        }
    }
}
