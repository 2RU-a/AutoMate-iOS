//
//  AddAddressView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI

struct AddAddressView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Address) -> Void
    
    @State private var title = ""
    @State private var city = "თბილისი"
    @State private var street = ""
    @State private var isDefault = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("მისამართის დასახელება")) {
                    TextField("მაგ: სახლი, სამსახური", text: $title)
                }
                
                Section(header: Text("დეტალები")) {
                    TextField("ქალაქი", text: $city)
                    TextField("ქუჩა, კორპუსი, ბინა", text: $street)
                }
                
                Section {
                    Toggle("დაყენდეს როგორც ძირითადი", isOn: $isDefault)
                }
            }
            .navigationTitle("ახალი მისამართი")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("გაუქმება") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("შენახვა") {
                        let newAddress = Address(title: title, city: city, street: street, isDefault: isDefault)
                        onSave(newAddress)
                        dismiss()
                    }
                    .disabled(title.isEmpty || street.isEmpty)
                }
            }
        }
    }
}
