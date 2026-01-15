//
//  ProductCard.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    
    // 1. დავაკავშიროთ ფავორიტების მენეჯერთან
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // სურათის სექცია
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 140)
                
                Image(systemName: product.imageName)
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                // 2. გულის ღილაკი დინამიური ლოგიკით
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(product)
                    }
                } label: {
                    Image(systemName: favoritesManager.isFavorite(product) ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(favoritesManager.isFavorite(product) ? .red : .gray)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2)
                }
                .padding(8)
            }
            
            // ინფორმაცია
            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top)
                
                Text(product.formattedPrice)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    ProductCard(product: Product(
        id: "1",
        name: "Edge 5W-30",
        brand: "Castrol",
        description: "Premium oil",
        price: 145.0,
        imageName: "drop.fill",
        categoryId: "5"
    ))
    .frame(width: 170)
    .padding()
}
