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
    @Published var hotDeals: [Product] = []
    @Published var isLoading: Bool = false
    
    private let service: HomeServiceProtocol
    private let db = Firestore.firestore()
    
    init(service: HomeServiceProtocol? = nil) {
        self.service = service ?? MockHomeService()
    }
    
    func loadData() async {
        isLoading = true
        
        do {
            // 1. პარალელურად წამოვიღოთ Offers და Categories (Mock)
            async let offersTask = service.fetchOffers()
            async let categoriesTask = service.fetchCategories()
            
            // 2. Firebase-იდან მხოლოდ "ცხელი შეთავაზებების" წამოღება
            let deals = await fetchHotDealsFromFirebase()
            
            // 3. მონაცემების მინიჭება
            self.offers = try await offersTask
            self.categories = try await categoriesTask
            self.hotDeals = deals
            
        } catch {
            print("ჩატვირთვის შეცდომა: \(error)")
        }
        
        isLoading = false
    }
    
    // განახლებული ფუნქცია სპეციალური ფილტრით
    private func fetchHotDealsFromFirebase() async -> [Product] {
        do {
            // მივმართავთ "products" კოლექციას და ვფილტრავთ isHotDeal ველის მიხედვით
            let snapshot = try await db.collection("products")
                .whereField("isHotDeal", isEqualTo: true) // 👈 ფილტრი
                .getDocuments()
            
            let fetched = snapshot.documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            }
            return fetched
        } catch {
            print("Hot Deals-ის წამოღება ვერ მოხერხდა: \(error)")
            return []
        }
    }
}
