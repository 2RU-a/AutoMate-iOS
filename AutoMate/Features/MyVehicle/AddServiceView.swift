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
    

    @State private var title = ""
    @State private var date = Date()
    @State private var mileage = "" // გარბენისთვის (String-ად ვიღებთ TextInput-ისთვის)
    @State private var adminNote = ""
    
    let serviceTypes = [
        "ძრავის ზეთის შეცვლა",
        "ძრავის ღვედის შეცვლა",
        "სამუხრუჭე ხუნდების შეცვლა",
        "სამუხრუჭე სითხის შეცვლა",
        "ტექ. დათვალიერება",
        "ჰაერის ფილტრის შეცვლა",
        "საბურავების შეცვლა",
        "სავალი ნაწილის შეკეთება"
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
                    
                    // გარბენის ველი
                    TextField("მიმდინარე გარბენი (კმ)", text: $mileage)
                        .keyboardType(.numberPad)
                    
                    DatePicker("თარიღი", selection: $date, in: Date()..., displayedComponents: .date)
                }
                
                Section(header: Text("დამატებითი შენიშვნა")) {
    
                    TextField("მაგ: რა უნდა გაითვალისწინოს ხელოსანმა და ა.შ.", text: $adminNote, axis: .vertical)
                        .lineLimit(4...10)
                }
                
                Section {
                    Button(action: saveService) {
                        Text("დაჯავშნა")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
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
    
    private func saveService() {
        // გარბენის String-დან Int-ში გადაყვანა
        let mileageInt = Int(mileage)
        
        let newService = ServiceRecord(
            title: title,
            date: date,
            mileage: mileageInt,
            isCompleted: false,
            note: adminNote
        )
        
        vehicleManager.addService(to: carId, service: newService)
        dismiss()
    }
}


//#Preview {
//    AddServiceView(carId: "test_car_123")
//}
