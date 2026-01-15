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
    
    @Published var favoriteProducts: [Product] = []
    
    // ვამოწმებთ, არის თუ არა პროდუქტი უკვე ფავორიტებში
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    // დამატება ან წაშლა (Toggle ლოგიკა)
    func toggleFavorite(_ product: Product) {
        if isFavorite(product) {
            favoriteProducts.removeAll { $0.id == product.id }
        } else {
            favoriteProducts.append(product)
        }
    }
}
