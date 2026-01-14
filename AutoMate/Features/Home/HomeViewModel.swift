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
    
    // 2. დარწმუნდი, რომ ცვლადებს უწერია @Published
    @Published var offers: [Offer] = []
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    
    private let service: HomeServiceProtocol
    
    init(service: HomeServiceProtocol? = nil) {
        self.service = service ?? MockHomeService()
    }
    
    func loadData() async {
        isLoading = true
        
        async let fetchedOffers = service.fetchOffers()
        async let fetchedCategories = service.fetchCategories()
        
        do {
            let (newOffers, newCategories) = try await (fetchedOffers, fetchedCategories)
            self.offers = newOffers
            self.categories = newCategories
        } catch {
            print("Error loading home data: \(error)")
        }
        
        isLoading = false
    }
}
