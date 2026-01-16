//
//  AddressManagementView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct AddressManagementView: View {
    // დროებითი მონაცემები (შემდეგში UserManager-ში გადავიტანთ)
    @State private var addresses: [Address] = [
        Address(title: "სახლი", city: "თბილისი", street: "ჭავჭავაძის გამზ. 1", isDefault: true),
        Address(title: "სამსახური", city: "თბილისი", street: "ყაზბეგის გამზ. 12", isDefault: false)
    ]
    
    @State private var isShowingAddAddress = false
    
    var body: some View {
        List {
            ForEach(addresses) { address in
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
            .onDelete(perform: deleteAddress)
        }
        .navigationTitle("ჩემი მისამართები")
        .toolbar {
            Button {
                isShowingAddAddress.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isShowingAddAddress) {
            AddAddressView { newAddress in
                addresses.append(newAddress)
            }
        }
    }
    
    private func deleteAddress(at offsets: IndexSet) {
        addresses.remove(atOffsets: offsets)
    }
}
