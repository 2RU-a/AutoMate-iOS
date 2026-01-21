//
//  AddCarView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI

struct AddCarView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vehicleManager = VehicleManager.shared
    
    // ახალი ცვლადი: თუ ეს არის nil - ვამატებთ, თუ არა - ვაედითებთ
    var carToEdit: MyCar?
    
    let carData: [String: [String]] = [
        "BMW": ["1 Series", "3 Series", "5 Series", "X5", "X6", "M4"],
        "Mercedes-Benz": ["A-Class", "C-Class", "E-Class", "S-Class", "GLE", "G-Wagon"],
        "Toyota": ["Camry", "Corolla", "RAV4", "Prius", "Land Cruiser"],
        "Audi": ["A3", "A4", "A6", "Q5", "Q7", "e-tron"]
    ]
    
    @State private var selectedMake = "BMW"
    @State private var selectedModel = ""
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var engine = ""
    @State private var vinCode = ""
    
    let years = Array((1990...Calendar.current.component(.year, from: Date())).reversed())

    var body: some View {
        NavigationStack {
            Form {
                Section("ავტომობილის მონაცემები") {
                    Picker("მწარმოებელი", selection: $selectedMake) {
                        ForEach(carData.keys.sorted(), id: \.self) { make in
                            Text(make).tag(make)
                        }
                    }
                    .onChange(of: selectedMake) { _, newValue in
                        selectedModel = carData[newValue]?.first ?? ""
                    }

                    Picker("მოდელი", selection: $selectedModel) {
                        if let models = carData[selectedMake] {
                            ForEach(models, id: \.self) { model in
                                Text(model).tag(model)
                            }
                        }
                    }

                    Picker("წელი", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                }

                Section("დამატებითი დეტალები") {
                    TextField("ძრავი (მაგ: 3.0 B58)", text: $engine)
                    TextField("VIN კოდი", text: $vinCode)
                        .textInputAutocapitalization(.characters)
                }
                
                Button(carToEdit == nil ? "შენახვა" : "განახლება") {
                    saveCar()
                }
                .frame(maxWidth: .infinity)
                .disabled(engine.isEmpty || selectedModel.isEmpty)
            }
            .navigationTitle(carToEdit == nil ? "დამატება" : "რედაქტირება")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("გაუქმება") { dismiss() }
                }
            }
            .onAppear(perform: setupInitialValues)
        }
    }
    
    // დამხმარე ფუნქცია მნიშვნელობების შესავსებად
    private func setupInitialValues() {
        if let car = carToEdit {
            selectedMake = car.make
            selectedModel = car.model
            selectedYear = Int(car.year) ?? 2024
            engine = car.engine
            vinCode = car.vinCode ?? ""
        } else if selectedModel.isEmpty {
            selectedModel = carData[selectedMake]?.first ?? ""
        }
    }
    
    //  შენახვის/განახლების ლოგიკა
    private func saveCar() {
        var car = MyCar(
            make: selectedMake,
            model: modelFormatted,
            year: String(selectedYear),
            engine: engine,
            vinCode: vinCode
        )
        
        if let carToEdit = carToEdit {
            // რედაქტირება: ვინარჩუნებთ არსებულ ID-ს
            car.id = carToEdit.id
            vehicleManager.addCar(car) // addCar ფუნქცია თავად მიხვდება განახლებას
        } else {
            // ახლის დამატება
            vehicleManager.addCar(car)
        }
        dismiss()
    }
    
    private var modelFormatted: String {
        selectedModel.isEmpty ? (carData[selectedMake]?.first ?? "") : selectedModel
    }
}
