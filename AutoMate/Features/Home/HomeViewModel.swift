//
//  HomeViewModel.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var offers: [Offer] = []
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    
    private let service: HomeServiceProtocol
    
    init(service: HomeServiceProtocol? = nil) {
        self.service = service ?? MockHomeService()
    }
    
    func loadData() async {
        isLoading = true
        do {
            // ერთდროულად ვიწერთ ყველაფერს
            async let offers = service.fetchOffers()
            async let categories = service.fetchCategories()
            
            // თუ fetchAllProducts დაამატე პროტოკოლში, გამოიყენე ის
            // თუ არა, დროებით პირდაპირ Product.sampleData მიანიჭე
            self.products = Product.sampleData
            
            self.offers = try await offers
            self.categories = try await categories
        } catch {
            print("ჩატვირთვის შეცდომა: \(error)")
        }
        isLoading = false
    }
}
