//
//  VehicleManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

//: MOCK
/*
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
*/


import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class VehicleManager: ObservableObject {
    static let shared = VehicleManager()
    
    @Published var cars: [MyCar] = []
    @Published var services: [String: [ServiceRecord]] = [:]
    
    private var db = Firestore.firestore()
    private var listeners: [String: ListenerRegistration] = [:]
    private var carsListener: ListenerRegistration? // მთავარი ლისენერი მანქანებისთვის
    
    init() {
        fetchCars()
    }
    
    // MARK: - Car Management

    func fetchCars() {
        // 1. პირდაპირ ვამოწმებთ Firebase-ის მიმდინარე მომხმარებელს
        guard let userId = Auth.auth().currentUser?.uid else {
            print("DEBUG: VehicleManager - No user ID found")
            self.cars = []
            return
        }

        // ვაუქმებთ ძველ ლისენერს თუ არსებობდა (რომ ექაუნთებს შორის გადართვისას არ აირიოს)
        carsListener?.remove()

        print("DEBUG: Fetching cars for user: \(userId)")

        // გზა: users -> USER_ID -> cars
        carsListener = db.collection("users").document(userId).collection("cars")
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("DEBUG: Error fetching cars: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                
                self?.cars = documents.compactMap { doc in
                    try? doc.data(as: MyCar.self)
                }
                
                // სერვისების წამოღება თითოეული მანქანისთვის
                self?.cars.forEach { car in
                    if let id = car.id {
                        self?.fetchServices(for: id)
                    }
                }
            }
    }

    func addCar(_ car: MyCar) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            // სწორი გზა: მომხმარებლის შიგნით
            _ = try db.collection("users").document(userId).collection("cars").addDocument(from: car)
            print("DEBUG: Car added successfully")
        } catch {
            print("DEBUG: Error adding car: \(error.localizedDescription)")
        }
    }
    
    func removeCar(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        offsets.forEach { index in
            let car = cars[index]
            if let carId = car.id {
                // სწორი გზა წაშლისთვის
                db.collection("users").document(userId).collection("cars").document(carId).delete { error in
                    if let error = error {
                        print("DEBUG: Error removing car: \(error.localizedDescription)")
                    } else {
                        self.listeners[carId]?.remove()
                        self.listeners.removeValue(forKey: carId)
                    }
                }
            }
        }
    }
    
    // MARK: - Service Management

    func fetchServices(for carId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard listeners[carId] == nil else { return }
        
        // სწორი გზა: users -> UID -> cars -> carId -> services
        let listener = db.collection("users").document(userId)
            .collection("cars").document(carId)
            .collection("services")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                
                let fetchedServices = documents.compactMap { doc in
                    try? doc.data(as: ServiceRecord.self)
                }
                
                DispatchQueue.main.async {
                    self?.services[carId] = fetchedServices
                }
            }
        
        listeners[carId] = listener
    }
    
    func addService(to carId: String, service: ServiceRecord) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            // სწორი გზა: users -> UID -> cars -> carId -> services
            _ = try db.collection("users").document(userId)
                .collection("cars").document(carId)
                .collection("services").addDocument(from: service)
        } catch {
            print("DEBUG: Error adding service: \(error.localizedDescription)")
        }
    }
}
