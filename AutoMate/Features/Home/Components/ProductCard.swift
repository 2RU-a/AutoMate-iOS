//
//  ProductCard.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    
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
                
                Button {
                    // Favorite action
                } label: {
                    Image(systemName: "heart")
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 1)
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
