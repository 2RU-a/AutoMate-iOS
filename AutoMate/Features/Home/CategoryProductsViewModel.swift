//
//  CategoryProductsViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class CategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var availableBrands: [String] = []
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
    }
    
    func loadProducts() async {
        isLoading = true
        
        do {
            // 1. მივმართავთ "products" კოლექციას და ვფილტრავთ categoryId-ით
            let snapshot = try await db.collection("products")
                .whereField("categoryId", isEqualTo: categoryId)
                .getDocuments()
            
            // 2. მონაცემების კონვერტაცია Product მოდელში
            let fetched = snapshot.documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            }
            
            // 3. შედეგის შენახვა
            self.products = fetched
            
            // 4. ბრენდების დინამიური ამოღება ფილტრისთვის
            self.availableBrands = Array(Set(fetched.map { $0.brand })).sorted()
            
        } catch {
            print("Firebase-იდან კატეგორიის პროდუქტების წამოღება ვერ მოხერხდა: \(error)")
        }
        
        isLoading = false
    }
}
