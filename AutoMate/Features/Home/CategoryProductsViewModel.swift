//
//  CategoryProductsViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import Foundation
import Combine


@MainActor
class CategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var availableBrands: [String] = []
    @Published var isLoading: Bool = false
    
    private let service = MockHomeService()
    let categoryId: String
    
    init(categoryId: String) {
        self.categoryId = categoryId
    }
    
    func loadProducts() async {
        isLoading = true
        do {
            let fetched = try await service.fetchProducts(for: categoryId)
            self.products = fetched
            // ბრენდების დინამიური ამოღება
            self.availableBrands = Array(Set(fetched.map { $0.brand })).sorted()
        } catch {
            print(error)
        }
        isLoading = false
    }
}
