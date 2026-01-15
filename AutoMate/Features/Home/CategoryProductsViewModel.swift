//
//  CategoryProductsViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    
    private let service = MockHomeService()
    let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
    }
    
    func loadProducts() async {
        isLoading = true
        do {
            // ვიძახებთ Mock სერვისიდან ჩვენს დამატებულ ფუნქციას
            self.products = try await service.fetchProducts(for: categoryId)
        } catch {
            print("Error loading products: \(error)")
        }
        isLoading = false
    }
}
