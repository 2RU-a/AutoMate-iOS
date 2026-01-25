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
    
    // MARK: - Published Properties
    @Published var offers: [Offer] = []
    @Published var categories: [Category] = []
    @Published var hotDeals: [Product] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
    init() {
        // აღარ ვიყენებთ HomeServiceProtocol-ს და MockHomeService-ს
    }
    
    // MARK: - Data Loading
    func loadData() async {
        // თუ მონაცემები უკვე გვაქვს, isLoading-ს აღარ ვრთავთ რადიკალურად,
        // რომ მომხმარებელს ეკრანი არ "აუციმციმდეს"
        if offers.isEmpty && categories.isEmpty {
            isLoading = true
        }
        
        // ვიყენებთ Structured Concurrency-ს პარალელური ჩატვირთვისთვის
        async let fetchedOffers = fetchOffersFromFirebase()
        async let fetchedCategories = fetchCategoriesFromFirebase()
        async let fetchedHotDeals = fetchHotDealsFromFirebase()
        
        // ველოდებით ყველა დავალების დასრულებას
        let (o, c, d) = await (fetchedOffers, fetchedCategories, fetchedHotDeals)
        
        self.offers = o
        self.categories = c
        self.hotDeals = d
        
        self.isLoading = false
    }
    
    // MARK: - Firebase Fetchers
    
    /// წამოიღებს სლაიდერის შეთავაზებებს
    private func fetchOffersFromFirebase() async -> [Offer] {
        do {
            let snapshot = try await db.collection("offers").getDocuments()
            return snapshot.documents.compactMap { document -> Offer? in
                try? document.data(as: Offer.self)
            }
        } catch {
            print("DEBUG: Error fetching offers: \(error.localizedDescription)")
            return []
        }
    }
    
    /// წამოიღებს კატეგორიებს (ძრავი, ზეთები და ა.შ.)
    private func fetchCategoriesFromFirebase() async -> [Category] {
        do {
            let snapshot = try await db.collection("categories").getDocuments()
            return snapshot.documents.compactMap { document -> Category? in
                try? document.data(as: Category.self)
            }
        } catch {
            print("DEBUG: Error fetching categories: \(error.localizedDescription)")
            return []
        }
    }
    
    /// წამოიღებს მხოლოდ იმ პროდუქტებს, რომლებსაც isHotDeal = true აქვთ
    private func fetchHotDealsFromFirebase() async -> [Product] {
        do {
            let snapshot = try await db.collection("products")
                .whereField("isHotDeal", isEqualTo: true)
                .getDocuments()
            
            return snapshot.documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            }
        } catch {
            print("DEBUG: Error fetching hot deals: \(error.localizedDescription)")
            return []
        }
    }
}
