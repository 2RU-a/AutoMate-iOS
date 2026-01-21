//
//  AddressManagementView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI
import MapKit

struct AddressManagementView: View {
    // ვიყენებთ მენეჯერს Dummy მონაცემების ნაცვლად
    @StateObject private var addressManager = AddressManager()
    @State private var isShowingAddAddress = false
    
    // რუკის საწყისი წერტილი
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack(spacing: 0) {
            // UIKit MapView
            UIKitMapView(region: $region)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                .shadow(radius: 2)

            List {
                Section(header: Text("შენახული ლოკაციები")) {
                    if addressManager.addresses.isEmpty {
                        Text("მისამართები არ არის")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    ForEach(addressManager.addresses) { address in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(address.title)
                                        .fontWeight(.bold)
                                    
                                    if address.isDefault {
                                        Text("ძირითადი")
                                            .font(.caption2)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Text(address.fullAddress)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: addressManager.deleteAddress) // ✅ წაშლა Firebase-დან
                }
            }
        }
        .navigationTitle("ჩემი მისამართები")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton() // საშუალებას მაძლევს წავშალო ელემენტები
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingAddAddress.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddAddress) {
            // გადავცემთ მენეჯერს, რომ ახალი მისამართი შეინახოს
            AddAddressQuickView(manager: addressManager)
        }
    }
}

struct AddAddressQuickView: View {
    @ObservedObject var manager: AddressManager
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var city = ""
    @State private var street = ""
    @State private var isDefault = false

    var body: some View {
        NavigationStack {
            Form {
                Section("ინფორმაცია") {
                    TextField("სათაური (მაგ: სახლი)", text: $title)
                    TextField("ქალაქი", text: $city)
                    TextField("ქუჩა და ნომერი", text: $street)
                    Toggle("დაყენდეს ძირითადად", isOn: $isDefault)
                }
                
                Button("შენახვა") {
                    let newAddress = UserAddress(
                        title: title,
                        city: city,
                        street: street,
                        isDefault: isDefault
                    )
                    manager.addAddress(newAddress)
                    dismiss()
                }
                .disabled(title.isEmpty || city.isEmpty || street.isEmpty)
            }
            .navigationTitle("ახალი მისამართი")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("გაუქმება") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AddressManagementView()
}
