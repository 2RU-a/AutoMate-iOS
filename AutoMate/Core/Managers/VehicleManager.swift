//
//  VehicleManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//


import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class VehicleManager: ObservableObject {
    static let shared = VehicleManager()
        
        @Published var cars: [MyCar] = []
        // სერვისები ინახება მანქანის ID-ის მიხედვით: ["CAR_ID": [ServiceRecord]]
        @Published var services: [String: [ServiceRecord]] = [:]
        
        private var db = Firestore.firestore()
        private var listeners: [String: ListenerRegistration] = [:]
        private var carsListener: ListenerRegistration?
        
        // განახლებული ლოგიკა ყველა დასრულებული სერვისის გამოსატანად
        var allCompletedServices: [ServiceRecord] {
            var completedServices: [ServiceRecord] = []
            
            // გადავუყვებით დიქშენერის ყველა მნიშვნელობას
            for (_, carServices) in services {
                let finished = carServices.filter { $0.isCompleted }
                completedServices.append(contentsOf: finished)
            }
            
            return completedServices.sorted { $0.date > $1.date }
        }
    
    init() {
        fetchCars()
    }
    
    // MARK: - Car Management

    func fetchCars() {
        // ვამოწმებ Firebase-ის მიმდინარე მომხმარებელს
        guard let userId = Auth.auth().currentUser?.uid else {
            print("DEBUG: VehicleManager - No user ID found")
            self.cars = []
            return
        }

        // ვაუქმებ ძველ ლისენერს თუ არსებობდა (რომ ექაუნთებს შორის გადართვისას არ აირიოს)
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
            if let carId = car.id {
                // თუ მანქანას ID უკვე აქვს, ვაახლებთ არსებულს (setData)
                try db.collection("users").document(userId)
                    .collection("cars").document(carId)
                    .setData(from: car)
            } else {
                // თუ ID არ აქვს, ვამატებთ ახალს (addDocument)
                _ = try db.collection("users").document(userId)
                    .collection("cars").addDocument(from: car)
            }
        } catch {
            print("DEBUG: Error saving car - \(error.localizedDescription)")
        }
    }
    
    
    func removeCar(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        offsets.forEach { index in
            let car = cars[index]
            guard let carId = car.id else { return }
            
            let carRef = db.collection("users").document(userId).collection("cars").document(carId)
            
            // 1. ვპოულობთ და ვშლით ყველა სერვისს, რომელიც ამ მანქანაზეა მიბმული
            carRef.collection("services").getDocuments { (snapshot, error) in
                if let error = error {
                    print("DEBUG: Error fetching services for deletion: \(error.localizedDescription)")
                }
                
                // სათითაოდ ვშლით თითოეულ სერვისს
                snapshot?.documents.forEach { doc in
                    doc.reference.delete()
                }
                
                // 2. მას შემდეგ რაც ქვე-კოლექცია დაიცლება, ვშლით თავად მანქანას
                carRef.delete { error in
                    if let error = error {
                        print("DEBUG: Error removing car: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: Car and its services successfully removed")
                        // ვთიშავთ ამ მანქანის ლისენერს
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
    
    func addService(to car: MyCar, service: ServiceRecord) { // carId-ს ნაცვლად მთლიანი car გადაეცემა
        guard let userId = Auth.auth().currentUser?.uid, let carId = car.id else { return }
        
        var newService = service
        newService.carName = "\(car.make) \(car.model)"
        
        do {
            _ = try db.collection("users").document(userId)
                .collection("cars").document(carId)
                .collection("services").addDocument(from: newService)
        } catch {
            print("DEBUG: Error adding service: \(error.localizedDescription)")
        }
    }
    
    func completeService(carId: String, serviceId: String, note: String) {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            // გზა დოკუმენტამდე: users -> UID -> cars -> carId -> services -> serviceId
            let serviceRef = db.collection("users").document(userId)
                .collection("cars").document(carId)
                .collection("services").document(serviceId)
            
            serviceRef.updateData([
                "isCompleted": true,
                "note": note
            ]) { error in
                if let error = error {
                    print("DEBUG: Error completing service: \(error.localizedDescription)")
                } else {
                    print("DEBUG: Service successfully marked as completed")
                }
            }
        }
}
