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
    // სტატიკური ეგზემპლარი, რომ ყველგან ერთი და იგივე კალათა გვქონდეს
    static let shared = CartManager()
    
    @Published var items: [Product] = []
    @Published var orderHistory: [Order] = []
    
    // ჯამური ფასი
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    // დამატება
    func addToCart(product: Product) {
        items.append(product)
    }
    
    // ამოღება
    func removeFromCart(product: Product) {
        items.removeAll { $0.id == product.id }
    }
    
    // გასუფთავება
    func clearCart() {
        items = []
    }
    
    func checkout() {
        let newOrder = Order(
            id: UUID().uuidString.prefix(8).uppercased(),
            date: Date(),
            items: items,
            totalPrice: totalPrice,
            status: .pending
        )
        orderHistory.insert(newOrder, at: 0) // ახალი შეკვეთა თავში
        clearCart()
    }
}
