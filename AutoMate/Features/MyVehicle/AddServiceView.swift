//
//  AddServiceView.swift
//  AutoMate
//
//  Created by oto rurua on 20.01.26.
//

import SwiftUI

struct AddServiceView: View {
    let carId: String
    @Environment(\.dismiss) var dismiss
    @StateObject private var vehicleManager = VehicleManager.shared
    
    // ფორმის მონაცემები
    @State private var title = ""
    @State private var date = Date()
    @State private var adminNote = "" // დავამატე State ცვლადი UIKit-ისთვის
    
    // სერვისების წინასწარ განსაზღვრული სია
    let serviceTypes = [
        "ძრავის ზეთის შეცვლა",
        "ძრავის ღვედის შეცვლა",
        "სამუხრუჭე ხუნდების შეცვლა",
        "სამუხრუჭე სითხის შეცვლა",
        "ტექ. დათვალიერება",
        "ჰაერის ფილტრის შეცვლა",
        "საბურავების შეცვლა"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("სერვისის დეტალები")) {
                    Picker("სერვისის ტიპი", selection: $title) {
                        Text("აირჩიეთ").tag("")
                        ForEach(serviceTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    DatePicker("თარიღი", selection: $date, displayedComponents: .date)
                }
                
                // UIKit-ის MultiLineTextField-ის გამოყენება
                Section(header: Text("შენიშვნა")) {
                    MultiLineTextField(text: $adminNote)
                        .frame(height: 120) // სიმაღლის მითითება აუცილებელია
                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                
                Section {
                    Button(action: saveService) {
                        HStack {
                            Spacer()
                            Text("დაჯავშნა")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("სერვისის დამატება")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("გაუქმება") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - შენახვის ფუნქცია
    private func saveService() {
        let newService = ServiceRecord(
            title: title,
            date: date,
            mileage: nil,
            isCompleted: false,
            note: adminNote.isEmpty ? nil : adminNote // ახლა note-ში ჩაიწერება UIKit-ის ტექსტი
        )
        
        vehicleManager.addService(to: carId, service: newService)
        dismiss()
    }
}


//#Preview {
//    AddServiceView(carId: "test_car_123")
//}
