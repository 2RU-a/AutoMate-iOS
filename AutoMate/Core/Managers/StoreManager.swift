//
//  StoreManager.swift
//  AutoMate
//
//  Created by oto rurua on 22.01.26.
//

import Foundation
import FirebaseFirestore
import Combine

class StoreManager: ObservableObject {
    @Published var products = [Product]()
    private var db = Firestore.firestore()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        db.collection("products").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("შეცდომა პროდუქტების წამოღებისას: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.products = documents.compactMap { document in
                try? document.data(as: Product.self)
            }
        }
    }
}
