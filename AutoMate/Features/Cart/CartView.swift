//
//  CartView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if cartManager.items.isEmpty {
                    emptyCartView
                } else {
                    List {
                        ForEach(cartManager.items) { product in
                            CartItemRow(product: product)
                        }
                        .onDelete(perform: deleteItems) // Swipe-to-delete ფუნქცია
                    }
                    .listStyle(PlainListStyle())
                    
                    checkoutSection
                }
            }
            .navigationTitle("კალათა")
        }
    }
    
    // MARK: - Components
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("შენი კალათა ცარიელია")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("დაამატე პროდუქტები მთავარი გვერდიდან")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var checkoutSection: some View {
        VStack(spacing: 15) {
            Divider()
            
            HStack {
                Text("ჯამური ღირებულება:")
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f ₾", cartManager.totalPrice))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            Button {
                // შეკვეთის გაფორმების ლოგიკა
            } label: {
                Text("შეკვეთის გაფორმება")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color(.systemBackground))
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = cartManager.items[index]
            cartManager.removeFromCart(product: product)
        }
    }
}
