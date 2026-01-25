//
//  CartManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth


class CartManager: ObservableObject {
    static let shared = CartManager()
    private let db = Firestore.firestore()
    
    @Published var items: [Product] = []
    @Published var orderHistory: [Order] = []
    @Published var isLoading: Bool = false
    
    private var cartListener: ListenerRegistration?
    private var ordersListener: ListenerRegistration?
    
    init() {
        if Auth.auth().currentUser != nil {
            setupListeners()
        }
    }
    
    // MARK: - Firebase Listeners
    
    func setupListeners() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: CartManager - No user logged in")
            return
        }
        
        cartListener?.remove()
        cartListener = db.collection("users").document(uid).collection("cart").document("current")            .addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                        print("DEBUG: Cart Listener Error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = snapshot?.data(),
                          let itemsArray = data["items"] as? [[String: Any]] else {
                        print("DEBUG: კალათის დოკუმენტი არ არსებობს ან ცარიელია") // ეს დაგვეხმარება დებაგში
                        self?.items = []
                        return
                    }
                
                let decodedItems = itemsArray.compactMap { dict -> Product? in
                    return Product(
                        id: dict["id"] as? String ?? "",
                        name: dict["name"] as? String ?? "",
                        brand: dict["brand"] as? String ?? "",
                        description: dict["description"] as? String ?? "",
                        price: dict["price"] as? Double ?? 0.0,
                        isHotDeal: dict["isHotDeal"] as? Bool ?? false, // 👈 გადმოვიდა წინ
                        imageName: dict["imageName"] as? String ?? "",
                        categoryId: dict["categoryId"] as? String ?? ""
                    )
                }
                
                DispatchQueue.main.async {
                    self?.items = decodedItems
                }
            }
        
        ordersListener?.remove()
        ordersListener = db.collection("users").document(uid).collection("orders")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let fetchedOrders = documents.compactMap { doc -> Order? in
                    try? doc.data(as: Order.self)
                }
                
                DispatchQueue.main.async {
                    self?.orderHistory = fetchedOrders
                }
            }
    }
    
    // MARK: - გამოთვლილი ცვლადები
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - კალათის ფუნქციები
    
    func addToCart(product: Product) {
        print("DEBUG: ვამატებ პროდუქტს: \(product.name)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var currentItems = items
        currentItems.append(product)
        
        updateFirebaseCart(uid: uid, newItems: currentItems)
    }
    
    func removeFromCart(product: Product) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var currentItems = items
        if let index = currentItems.firstIndex(where: { $0.id == product.id }) {
            currentItems.remove(at: index)
            updateFirebaseCart(uid: uid, newItems: currentItems)
        }
    }
    
    func clearCart() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).collection("cart").document("current").delete()
    }
    
    private func updateFirebaseCart(uid: String, newItems: [Product]) {
        let itemsData = newItems.map { product -> [String: Any] in
            return [
                "id": product.id,
                "name": product.name,
                "brand": product.brand,
                "description": product.description ?? "",
                "price": product.price,
                "imageName": product.imageName,
                "categoryId": product.categoryId,
                "isHotDeal": product.isHotDeal
            ]
        }
        
        db.collection("users").document(uid).collection("cart").document("current")
            .setData(["items": itemsData], merge: true) { error in
            if let error = error {
                print("DEBUG: Firebase Update Error: \(error.localizedDescription)")
            } else {
                print("DEBUG: Cart successfully updated in Firebase")
            }
        }
    }
    
    // MARK: - Checkout
    
    func checkout() {
        guard let uid = Auth.auth().currentUser?.uid, !items.isEmpty else { return }
        
        let newOrder = Order(
            id: String(UUID().uuidString.prefix(8).uppercased()),
            date: Date(),
            items: items,
            totalPrice: totalPrice,
            status: .pending
        )
        
        do {
            try db.collection("users").document(uid).collection("orders").addDocument(from: newOrder)
            clearCart()
        } catch {
            print("DEBUG: Checkout error - \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        cartListener?.remove()
        ordersListener?.remove()
        items = []
        orderHistory = []
    }
}
