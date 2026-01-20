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

class VehicleManager: ObservableObject {
    static let shared = VehicleManager()
    
    @Published var cars: [MyCar] = []
    // [მანქანისID: სერვისებისსია] - ინახავს თითოეული მანქანის სერვისებს
    @Published var services: [String: [ServiceRecord]] = [:]
    
    private var db = Firestore.firestore()
    private var listeners: [String: ListenerRegistration] = [:] // ლისენერების სამართავად
    
    init() {
        fetchCars()
    }
    
    // MARK: - Car Management
    
    /// წამოიღებს ყველა მანქანას Cloud-დან
    func fetchCars() {
        db.collection("cars").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching cars: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.cars = documents.compactMap { doc in
                try? doc.data(as: MyCar.self)
            }
            
            // ავტომატურად ჩავრთოთ ლისენერები სერვისებისთვის თითოეული მანქანისთვის
            self?.cars.forEach { car in
                if let id = car.id {
                    self?.fetchServices(for: id)
                }
            }
        }
    }
    
    /// ახალი მანქანის დამატება
    func addCar(_ car: MyCar) {
        do {
            _ = try db.collection("cars").addDocument(from: car)
        } catch {
            print("Error adding car: \(error.localizedDescription)")
        }
    }
    
    /// მანქანის წაშლა (შლის მანქანასაც და მის ქვე-კოლექციებსაც)
    func removeCar(at offsets: IndexSet) {
        offsets.forEach { index in
            let car = cars[index]
            if let documentId = car.id {
                // წაშლა ბაზიდან
                db.collection("cars").document(documentId).delete { error in
                    if let error = error {
                        print("Error removing car: \(error.localizedDescription)")
                    } else {
                        // წავშალოთ ლოკალური ლიზენერიც
                        self.listeners[documentId]?.remove()
                        self.listeners.removeValue(forKey: documentId)
                    }
                }
            }
        }
    }
    
    // MARK: - Service Management (Firestore Sub-collections)
    
    /// კონკრეტული მანქანის სერვისების წამოღება
    func fetchServices(for carId: String) {
        // თუ უკვე გვაქვს აქტიური ლისენერი, აღარ გვინდა ახლის დამატება
        guard listeners[carId] == nil else { return }
        
        let listener = db.collection("cars").document(carId).collection("services")
            .order(by: "date", descending: true) // დალაგება თარიღით
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
    
    /// კონკრეტულ მანქანაზე სერვისის მიბმა
    func addService(to carId: String, service: ServiceRecord) {
        do {
            _ = try db.collection("cars").document(carId).collection("services").addDocument(from: service)
        } catch {
            print("Error adding service: \(error.localizedDescription)")
        }
    }
}
