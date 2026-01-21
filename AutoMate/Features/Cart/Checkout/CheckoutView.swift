//
//  CheckoutView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var cartManager = CartManager.shared
    @Environment(\.dismiss) var dismiss
    
    // ფორმის მონაცემები
    @State private var selectedPaymentMethod = "ბარათით გადახდა"
    @State private var selectedAddress: UserAddress = UserAddress(title: "სახლი", city: "თბილისი", street: "ჭავჭავაძის გამზ. 1", isDefault: true)
    
    @State private var showAddressPicker = false
    @State private var showConfirmation = false
    
    // დროებითი მისამართების სია (მომავალში UserManager-იდან წამოვა)
    @State private var savedAddresses = [
        UserAddress(title: "სახლი", city: "თბილისი", street: "ჭავჭავაძის გამზ. 1", isDefault: true),
        UserAddress(title: "სამსახური", city: "თბილისი", street: "ყაზბეგის გამზ. 12", isDefault: false)
    ]
    
    var body: some View {
        VStack {
            List {
                // 1. მისამართის შერჩევა
                Section(header: Text("მიწოდების მისამართი")) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedAddress.title)
                                .fontWeight(.bold)
                            Text(selectedAddress.fullAddress)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("შეცვლა") {
                            showAddressPicker.toggle()
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical, 5)
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
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.formattedPrice)
                        }
                        .font(.caption)
                    }
                    
                    HStack {
                        Text("ჯამი")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f ₾", cartManager.totalPrice))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // გადახდის ღილაკი
            Button {
                processOrder()
            } label: {
                Text("\(selectedPaymentMethod) — \(String(format: "%.2f ₾", cartManager.totalPrice))")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(cartManager.items.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(cartManager.items.isEmpty)
            .padding()
        }
        .navigationTitle("გაფორმება")
        // მისამართის ამომრჩევი Sheet
        .sheet(isPresented: $showAddressPicker) {
            addressPickerSheet
        }
        .alert("შეკვეთა მიღებულია!", isPresented: $showConfirmation) {
            Button("კარგი") { dismiss() }
        } message: {
            Text("თქვენი შეკვეთა წარმატებით გაფორმდა მისამართზე: \(selectedAddress.fullAddress)")
        }
    }
    
    // MARK: - Address Picker Sheet
    private var addressPickerSheet: some View {
        NavigationStack {
            List(savedAddresses) { address in
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
                        if let selectedId = selectedAddress.id, let currentId = address.id, selectedId == currentId {
                            Image(systemName: "checkmark").foregroundColor(.blue)
                        }                    }
                }
                .foregroundColor(.primary)
            }
            .navigationTitle("აირჩიეთ მისამართი")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("დახურვა") { showAddressPicker = false }
            }
        }
        .presentationDetents([.fraction(0.7)])
    }
    
    private func processOrder() {
        cartManager.checkout()
        showConfirmation = true
    }
}

#Preview{
    CheckoutView()
}
