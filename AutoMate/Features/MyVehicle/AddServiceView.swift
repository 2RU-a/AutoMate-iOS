//
//  AddServiceView.swift
//  AutoMate
//
//  Created by oto rurua on 20.01.26.
//

import SwiftUI

import SwiftUI

struct AddServiceView: View {
    let car: MyCar // String carId-ს ნაცვლად ვიღებთ მთლიან მანქანას
    @Environment(\.dismiss) var dismiss
    @StateObject private var vehicleManager = VehicleManager.shared
    @StateObject private var lang = LocalizationManager.shared // 👈 თარგმანისთვის

    @State private var title = ""
    @State private var date = Date()
    @State private var mileage = ""
    @State private var adminNote = ""
    
    let serviceTypes = [
        "oil_change",           // "ძრავის ზეთის შეცვლა"
        "belt_change",          // "ძრავის ღვედის შეცვლა"
        "brake_pads",           // "სამუხრუჭე ხუნდების შეცვლა"
        "brake_fluid",          // "სამუხრუჭე სითხის შეცვლა"
        "tech_inspection",       // "ტექ. დათვალიერება"
        "air_filter",           // "ჰაერის ფილტრის შეცვლა"
        "tire_change",          // "საბურავების შეცვლა"
        "suspension_repair"     // "სავალი ნაწილის შეკეთება"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(lang.t("service_details"))) {
                    Picker(lang.t("service_type"), selection: $title) {
                        Text(lang.t("select")).tag("")
                        ForEach(serviceTypes, id: \.self) { type in
                            Text(lang.t(type)).tag(lang.t(type)) // ვინახავთ ნათარგმნ სახელს
                        }
                    }
                    
                    TextField(lang.t("current_mileage_km"), text: $mileage)
                        .keyboardType(.numberPad)
                    
                    DatePicker(lang.t("date"), selection: $date, in: Date()..., displayedComponents: .date)
                }
                
                Section(header: Text(lang.t("additional_note"))) {
                    TextField(lang.t("note_placeholder"), text: $adminNote, axis: .vertical)
                        .lineLimit(4...10)
                }
                
                Section {
                    Button(action: saveService) {
                        Text(lang.t("Book Service"))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle(lang.t("add_service_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(lang.t("cancel")) { dismiss() }
                }
            }
        }
    }
    
    private func saveService() {
        let mileageInt = Int(mileage)
        
        let newService = ServiceRecord(
            title: title,
            date: date,
            mileage: mileageInt,
            isCompleted: false,
            note: adminNote,
            carName: "" // ეს VehicleManager-ში შეივსება
        )
        
        vehicleManager.addService(to: car, service: newService)
        dismiss()
    }
}
