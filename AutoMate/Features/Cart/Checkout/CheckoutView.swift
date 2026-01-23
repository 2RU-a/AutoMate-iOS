//
//  CheckoutView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CheckoutView: View {
    @StateObject private var cartManager = CartManager.shared
    // ვიყენებთ რეალურ მენეჯერს მისამართებისთვის
    @StateObject private var addressManager = AddressManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPaymentMethod = "ბარათით გადახდა"
    // თავიდან ვირჩევთ Default მისამართს, თუ არსებობს
    @State private var selectedAddress: UserAddress?
    
    @State private var showAddressPicker = false
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            List {
                // 1. მისამართის შერჩევა
                Section(header: Text("მიწოდების მისამართი")) {
                    if let address = selectedAddress ?? addressManager.addresses.first(where: { $0.isDefault }) ?? addressManager.addresses.first {
                        addressRow(address: address)
                    } else {
                        // თუ მისამართი საერთოდ არ აქვს დამატებული
                        NavigationLink(destination: AddressManagementView()) {
                            Text("დაამატეთ მისამართი")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                // 2. გადახდის მეთოდი
                Section(header: Text("გადახდის მეთოდი")) {
                    Picker("მეთოდი", selection: $selectedPaymentMethod) {
                        Text("ბარათით").tag("ბარათით გადახდა")
                        Text("ნაღდი").tag("ნაღდი ანგარიშსწორება")
                        Text("Apple Pay").tag("Apple Pay")
                    }
                    .pickerStyle(.segmented)
                }
                
                // 3. შეჯამება
                Section(header: Text("შეკვეთის შეჯამება")) {
                    ForEach(cartManager.items) { item in
                        HStack(spacing: 10) {
                            AsyncImage(url: URL(string: item.imageName)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                            
                            Text(item.name)
                                .lineLimit(1)
                            Spacer()
                            Text(item.formattedPrice)
                        }
                        .font(.caption)
                    }
                    HStack {
                        Text("ჯამი").fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f ₾", cartManager.totalPrice))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // გადახდის ღილაკი
            confirmButton
        }
        .navigationTitle("გაფორმება")
        .onAppear {
            // საწყისი მისამართის დაყენება
            if selectedAddress == nil {
                selectedAddress = addressManager.addresses.first(where: { $0.isDefault }) ?? addressManager.addresses.first
            }
        }
        .sheet(isPresented: $showAddressPicker) {
            addressPickerSheet
        }
        .alert("შეკვეთა მიღებულია!", isPresented: $showConfirmation) {
            Button("კარგი") { dismiss() }
        } message: {
            Text("თქვენი შეკვეთა წარმატებით გაფორმდა!")
        }
    }
    
    // MARK: - Components
    
    private func addressRow(address: UserAddress) -> some View {
        HStack {
            Image(systemName: "mappin.and.ellipse").foregroundColor(.red)
            VStack(alignment: .leading, spacing: 4) {
                Text(address.title).fontWeight(.bold)
                Text(address.fullAddress).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Button("შეცვლა") { showAddressPicker.toggle() }
                .font(.caption).fontWeight(.bold).foregroundColor(.blue)
        }
        .padding(.vertical, 5)
    }
    
    private var confirmButton: some View {
        Button {
            processOrder()
        } label: {
            Text("\(selectedPaymentMethod) — \(String(format: "%.2f ₾", cartManager.totalPrice))")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(canPlaceOrder ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(!canPlaceOrder)
        .padding()
    }
    
    private var canPlaceOrder: Bool {
        !cartManager.items.isEmpty && (selectedAddress != nil || !addressManager.addresses.isEmpty)
    }
    
    private var addressPickerSheet: some View {
        NavigationStack {
            List(addressManager.addresses) { address in
                Button {
                    selectedAddress = address
                    showAddressPicker = false
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(address.title).fontWeight(.semibold)
                            Text(address.fullAddress).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedAddress?.id == address.id {
                            Image(systemName: "checkmark").foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
            .navigationTitle("აირჩიეთ მისამართი")
            .toolbar {
                Button("დახურვა") { showAddressPicker = false }
            }
        }
        .presentationDetents([.fraction(0.6)])
    }
    
    private func processOrder() {
        cartManager.checkout()
        showConfirmation = true
    }
}

#Preview{
    CheckoutView()
}
