//
//  CartItemRow.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct CartItemRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 70, height: 70)
                
                if let url = URL(string: product.imageName), url.scheme != nil {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: product.imageName)
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 70, height: 70)
            
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
