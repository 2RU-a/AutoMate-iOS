//
//  HomeViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var offers: [Offer] = []
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    
    private let service: HomeServiceProtocol
    private let db = Firestore.firestore() // Firestore რეფერენსი
    
    init(service: HomeServiceProtocol? = nil) {
        self.service = service ?? MockHomeService()
    }
    
    func loadData() async {
        isLoading = true
        
        // 1. პარალელურად ვიწყებთ Mock მონაცემების წამოღებას (Offers, Categories)
        do {
            async let offersTask = service.fetchOffers()
            async let categoriesTask = service.fetchCategories()
            
            // 2. Firebase-იდან პროდუქტების წამოღება
            // ვიყენებთ await-ს რათა დაველოდოთ პროდუქტების ჩატვირთვას
            let firebaseProducts = await fetchProductsFromFirebase()
            
            // 3. მონაცემების მინიჭება
            self.offers = try await offersTask
            self.categories = try await categoriesTask
            
            // ნაცვლად სატესტო მონაცემებისა, მიანიჭე მხოლოდ ის, რაც ბაზიდან მოვიდა
            self.products = firebaseProducts
            
        } catch {
            print("ჩატვირთვის შეცდომა: \(error)")
        }
        
        isLoading = false
    }
    
    // ✅ ახალი ფუნქცია Firebase-ისთვის
    private func fetchProductsFromFirebase() async -> [Product] {
        do {
            let snapshot = try await db.collection("products").getDocuments()
            let fetchedProducts = snapshot.documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            }
            return fetchedProducts
        } catch {
            print("Firebase-იდან პროდუქტების წამოღება ვერ მოხერხდა: \(error)")
            return []
        }
    }
}
