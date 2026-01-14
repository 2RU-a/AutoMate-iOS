//
//  CarDetailViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI
import Foundation
import Combine // 👈 აუცილებელია ObservableObject-ისთვის

@MainActor
class CarDetailViewModel: ObservableObject {
    
    @Published var services: [ServiceItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let carService: CarServiceProtocol
    private let carId: String
    
    // აქაც ვიყენებთ Mock-ს დეფოლტად
    init(carId: String, carService: CarServiceProtocol? = nil) {
        self.carId = carId
        self.carService = carService ?? MockCarService()
    }
    
    func loadServices() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedServices = try await carService.fetchServiceHistory(for: carId)
            self.services = fetchedServices.sorted(by: { $0.date > $1.date }) // ახლები ზემოთ
        } catch {
            self.errorMessage = "ისტორიის წამოღება ვერ მოხერხდა ან ჯერ არ დამატებულა"
        }
        
        isLoading = false
    }
}
