//
//  FavoritesManager.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI
import Combine

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteProducts: [Product] = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private let favoritesKey = "saved_favorites"
    
    private init() {
        loadFavorites()
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    func toggleFavorite(_ product: Product) {
        if isFavorite(product) {
            favoriteProducts.removeAll(where: { $0.id == product.id })
        } else {
            favoriteProducts.append(product)
        }
    }
    
    // MARK: - Persistence
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteProducts) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            self.favoriteProducts = decoded
        }
    }
}
