//
//  MyCarViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MyCarViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cars: [MyCar] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let vehicleManager = VehicleManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        // ვაკავშირებთ ViewModel-ის მასივს მენეჯერის რეალურ მონაცემებთან
        vehicleManager.$cars
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedCars in
                self?.cars = updatedCars
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    /// იძახებს მენეჯერში არსებულ წაშლის ფუნქციას ინდექსების მიხედვით.
    /// გამოიყენება პირდაპირ List-ის .onDelete(perform:) მოდიფიკატორში.
    func removeCars(at offsets: IndexSet) {
        vehicleManager.removeCar(at: offsets)
    }
    
    /// თუ გჭირდება კონკრეტული ობიექტის წაშლა (მაგალითად, ღილაკზე დაჭერით და არა Swipe-ით)
    func deleteSingleCar(_ car: MyCar) {
        if let index = cars.firstIndex(where: { $0.id == car.id }) {
            vehicleManager.removeCar(at: IndexSet(integer: index))
        }
    }
    
    func loadCars() {
        // რადგან VehicleManager-ს აქვს რეალურ დროში მომუშავე Listener (SnapshotListener),
        // ხელით ჩატვირთვა (fetch) ხშირად საჭირო აღარ არის, რადგან მონაცემები თავისით განახლდება.
        isLoading = true
        vehicleManager.fetchCars()
        isLoading = false
    }
}
