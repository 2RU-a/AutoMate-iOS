//
//  MyCarViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI

@MainActor // ეს უზრუნველყოფს, რომ UI განახლებები მოხდეს მთავარ ნაკადში
class MyCarViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI State)
    @Published var cars: [Car] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let carService: CarServiceProtocol
    
    // MARK: - Initializer (Dependency Injection)
    // default მნიშვნელობად აქვს MockCarService, რაც ამარტივებს პრევიუს
    init(carService: CarServiceProtocol = MockCarService()) {
        self.carService = carService
    }
    
    // MARK: - Methods
    
    func loadCars() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // მონაცემების წამოღება სერვისიდან
            let fetchedCars = try await carService.fetchMyCars()
            self.cars = fetchedCars
        } catch {
            // შეცდომის დამუშავება
            self.errorMessage = "მონაცემების წამოღება ვერ მოხერხდა: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // ფუნქცია მომავლისთვის: მანქანის წაშლა სიიდან
    func deleteCar(at indexSet: IndexSet) {
        // აქ ჯერ ლოკალურად წავშლით, შემდეგ კი სერვისს დავამატებთ წაშლის ფუნქციას
        cars.remove(atOffsets: indexSet)
    }
}
