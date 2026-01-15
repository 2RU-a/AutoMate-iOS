//
//  FavoritesView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if favoritesManager.favoriteProducts.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favoritesManager.favoriteProducts) { product in
                            // ვიყენებთ NavigationLink-ს, რომ აქედანაც გადავიდეთ დეტალებზე
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                FavoriteProductCard(product: product)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("ფავორიტები")
        .background(Color(.systemGroupedBackground))
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 100)
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
            Text("ფავორიტების სია ცარიელია")
                .font(.headline)
            Text("მონიშნე პროდუქტები გულის ღილაკით")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
