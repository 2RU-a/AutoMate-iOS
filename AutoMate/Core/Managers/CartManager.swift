//
//  CartManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI
import Combine

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var items: [Product] = [] {
        didSet { saveCart() }
    }
    
    @Published var orderHistory: [Order] = [] {
        didSet { saveOrders() }
    }
    
    // შენახვის გასაღებები (Keys)
    private let cartKey = "saved_cart_items"
    private let ordersKey = "saved_order_history"
    
    init() {
        loadData()
    }
    
    // MARK: - გამოთვლილი ცვლადები
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - ფუნქციები
    func addToCart(product: Product) {
        items.append(product)
    }
    
    func removeFromCart(product: Product) {
        items.removeAll { $0.id == product.id }
    }
    
    func clearCart() {
        items = []
    }
    
    func checkout() {
        guard !items.isEmpty else { return }
        
        let newOrder = Order(
            id: String(UUID().uuidString.prefix(8).uppercased()),
            date: Date(),
            items: items,
            totalPrice: totalPrice,
            status: .pending
        )
        
        // ჯერ ვამატებთ ისტორიაში, მერე ვასუფთავებთ კალათას
        orderHistory.insert(newOrder, at: 0)
        clearCart()
    }
    
    // MARK: - მონაცემთა შენახვა (Persistence)
    
    private func saveCart() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orderHistory) {
            UserDefaults.standard.set(encoded, forKey: ordersKey)
        }
    }
    
    private func loadData() {
        // კალათის ჩატვირთვა
        if let savedItems = UserDefaults.standard.data(forKey: cartKey),
           let decodedItems = try? JSONDecoder().decode([Product].self, from: savedItems) {
            self.items = decodedItems
        }
        
        // ისტორიის ჩატვირთვა
        if let savedOrders = UserDefaults.standard.data(forKey: ordersKey),
           let decodedOrders = try? JSONDecoder().decode([Order].self, from: savedOrders) {
            self.orderHistory = decodedOrders
        }
    }
}
