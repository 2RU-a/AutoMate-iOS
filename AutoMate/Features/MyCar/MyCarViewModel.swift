//
//  MyCarViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI
import Combine

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
    init(carService: CarServiceProtocol? = nil) {
            // თუ carService არ გადმოეცა, ვქმნით მას "შიგნით", რაც უსაფრთხოა
            self.carService = carService ?? MockCarService()
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
    
    // MARK: - Car Deletion Logic
    
    func deleteCar(_ car: Car) async {
        isLoading = true
        
        do {
            // 1. ვეუბნებით სერვერს/ბაზას რომ წაშალოს
            try await carService.deleteCar(id: car.id)
            
            // 2. თუ სერვერმა იმუშავა, ვშლით ლოკალური სიიდანაც
            if let index = cars.firstIndex(where: { $0.id == car.id }) {
                cars.remove(at: index)
            }
        } catch {
            self.errorMessage = "წაშლა ვერ მოხერხდა: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
