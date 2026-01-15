//
//  FavoriteProductCard.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct FavoriteProductCard: View {
    let product: Product
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 120) // უფრო დაბალი სიმაღლე
                
                Image(systemName: product.imageName)
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                // გულის ღილაკი წასაშლელად
                Button {
                    favoritesManager.toggleFavorite(product)
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(6)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(6)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text(product.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(product.formattedPrice)
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 4)
        }
        .padding(6)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}
