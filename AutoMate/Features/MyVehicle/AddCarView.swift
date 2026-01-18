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
    
    // 1. მონაცემები Picker-ისთვის
    let carData: [String: [String]] = [
        "BMW": ["1 Series", "3 Series", "5 Series", "X5", "X6", "M4"],
        "Mercedes-Benz": ["A-Class", "C-Class", "E-Class", "S-Class", "GLE", "G-Wagon"],
        "Toyota": ["Camry", "Corolla", "RAV4", "Prius", "Land Cruiser"],
        "Audi": ["A3", "A4", "A6", "Q5", "Q7", "e-tron"]
    ]
    
    // 2. ფორმის State-ები
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
                    // ბრენდის არჩევა
                    Picker("მარკა", selection: $selectedMake) {
                        ForEach(carData.keys.sorted(), id: \.self) { make in
                            Text(make).tag(make)
                        }
                    }
                    .onChange(of: selectedMake) { oldValue, newValue in
                        selectedModel = carData[newValue]?.first ?? ""
                    }
                    // მოდელის არჩევა (დინამიურად იცვლება მარკის მიხედვით)
                    Picker("მოდელი", selection: $selectedModel) {
                        if let models = carData[selectedMake] {
                            ForEach(models, id: \.self) { model in
                                Text(model).tag(model)
                            }
                        }
                    }

                    // წლის არჩევა
                    Picker("წელი", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                }

                Section("დამატებითი დეტალები") {
                    TextField("ძრავი (მაგ: 3.0 B58)", text: $engine)
                    TextField("VIN კოდი", text: $vinCode)
                        .autocapitalization(.allCharacters)
                }
                
                Button("შენახვა") {
                    let newCar = MyCar(
                        make: selectedMake,
                        model: selectedModel,
                        year: String(selectedYear),
                        engine: engine,
                        vinCode: vinCode
                    )
                    vehicleManager.addCar(newCar)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .disabled(engine.isEmpty) // ძრავის მითითება სავალდებულოა
            }
            .navigationTitle("ავტომობილის დამატება")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("გაუქმება") { dismiss() }
                }
            }
            .onAppear {
                // პირველადი მნიშვნელობის მინიჭება მოდელისთვის
                if selectedModel.isEmpty {
                    selectedModel = carData[selectedMake]?.first ?? ""
                }
            }
        }
    }
}
