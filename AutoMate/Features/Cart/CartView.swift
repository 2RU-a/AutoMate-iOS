//
//  CartView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        NavigationStack {
            Group {
                if authManager.isAnonymous {
                    GuestPlaceholderView(
                        title: "თქვენი კალათა",
                        message: "პროდუქტების შესაძენად და შეკვეთის გასაფორმებლად გთხოვთ გაიაროთ რეგისტრაცია"
                    )
                } else {
                    mainCartLayout
                }
            }
            .navigationTitle("კალათა")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Main Cart Layout
    private var mainCartLayout: some View {
        VStack(spacing: 0) {
            // ვიღებთ მხოლოდ აქტიურ შეკვეთებს ისტორიიდან
            let activeOrders = cartManager.orderHistory.filter { $0.status == .pending || $0.status == .processing }
            
            if cartManager.items.isEmpty && activeOrders.isEmpty {
                emptyCartView
            } else {
                List {
                    // სექცია 1: კალათაში არსებული ნივთები
                    if !cartManager.items.isEmpty {
                        Section(header: Text("ნივთები კალათაში")) {
                            ForEach(cartManager.items) { product in
                                Text(product.name) // დროებითი ტექსტი შესამოწმებლად
                                CartItemRow(product: product)
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    
                    // სექცია 2: აქტიური შეკვეთები (გამოჩნდება გადახდის შემდეგ)
                    if !activeOrders.isEmpty {
                        Section(header: Text("აქტიური შეკვეთები")) {
                            ForEach(activeOrders) { order in
                                ActiveOrderRow(order: order)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // ქვედა პანელი მხოლოდ მაშინ ჩანს, თუ კალათაში რამე გვაქვს
                if !cartManager.items.isEmpty {
                    checkoutSection
                }
            }
        }
    }
    
    // MARK: - Components
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("შენი კალათა ცარიელია")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("დაამატე პროდუქტები ან შეამოწმე აქტიური შეკვეთები")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
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
            
            NavigationLink(destination: CheckoutView()) {
                Text("შეკვეთის გაფორმება")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = cartManager.items[index]
            cartManager.removeFromCart(product: product)
        }
    }
}

// MARK: - Active Order Row Component
struct ActiveOrderRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "box.truck.fill")
                    .foregroundColor(.orange)
                Text("შეკვეთა #\(order.id)")
                    .fontWeight(.bold)
                Spacer()
                Text(order.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .cornerRadius(5)
            }
            
            Text("\(order.items.count) ნივთი • \(String(format: "%.2f ₾", order.totalPrice))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: 0.3) // ვიზუალური პროგრესი
                .tint(.orange)
        }
        .padding(.vertical, 8)
    }
}
