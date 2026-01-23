//
//  FavoritesView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        NavigationStack {
            Group {
                if favoritesManager.favoriteProducts.isEmpty {
                    emptyFavoritesView
                } else {
                    List {
                        ForEach(favoritesManager.favoriteProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                favoriteRow(product: product)
                            }
                        }
                        .onDelete { indexSet in
                            // სლაიდით წაშლის შესაძლებლობა
                            indexSet.forEach { index in
                                let product = favoritesManager.favoriteProducts[index]
                                favoritesManager.toggleFavorite(product)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("ფავორიტები")
        }
    }
    
    private var emptyFavoritesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.4))
            Text("ფავორიტების სია ცარიელია")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private func favoriteRow(product: Product) -> some View {
        HStack(spacing: 15) {
            // სურათი Firebase-იდან
            AsyncImage(url: URL(string: product.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.1)
            }
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.brand)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text(product.name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text(product.formattedPrice)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
