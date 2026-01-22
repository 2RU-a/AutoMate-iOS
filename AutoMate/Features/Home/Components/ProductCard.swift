//
//  ProductCard.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. სურათის ზონა (მკაცრად განსაზღვრული პროპორციით)
            ZStack(alignment: .topTrailing) {
                Color(.secondarySystemBackground)
                
                Group {
                    if let url = URL(string: product.imageName), url.scheme != nil {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity) // აიძულებს სიგანის შევსებას
                                    .frame(height: 140) // მკაცრი სიმაღლე
                                    .clipped()
                            case .failure:
                                fallbackImage
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        fallbackImage
                    }
                }
                
                // ფავორიტის ღილაკი
                favoriteButtonSection
            }
            .frame(height: 140)
            .cornerRadius(12)
            
            // 2. ინფორმაციის ზონა
            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Text(product.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    // ფიქსირებული სიმაღლე ტექსტისთვის, რომ 1-ხაზიანი და 2-ხაზიანი სახელები ერთნაირად იჯდეს
                    .frame(height: 34, alignment: .topLeading)
                
                Text(product.formattedPrice)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 2)
            }
            .padding(.top, 8)
            .padding(.horizontal, 4)
            
            Spacer(minLength: 0)
        }
        .padding(8)
        // აი ეს ბლოკავს მთლიან ქარდს
        .frame(maxWidth: .infinity)
        .frame(height: 235)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // დამხმარე კომპონენტები
    private var favoriteButtonSection: some View {
        Button {
            withAnimation(.spring()) {
                favoritesManager.toggleFavorite(product)
            }
        } label: {
            Image(systemName: favoritesManager.isFavorite(product) ? "heart.fill" : "heart")
                .font(.system(size: 12))
                .foregroundColor(favoritesManager.isFavorite(product) ? .red : .gray)
                .padding(6)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 1)
        }
        .padding(6)
    }
    
    private var fallbackImage: some View {
        Image(systemName: product.imageName.contains("/") ? "photo" : product.imageName)
            .font(.system(size: 30))
            .foregroundColor(.gray.opacity(0.5))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//Preview
/*#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ProductCard(product: Product(
            id: "1",
            name: "Edge 5W-30",
            brand: "Castrol",
            description: "Premium oil",
            price: 145.0,
            imageName: "drop.fill",
            categoryId: "5"
        ))
        
        ProductCard(product: Product(
            id: "2",
            name: "ამნთები სანთელი",
            brand: "NGK",
            description: "Iridium",
            price: 25.0,
            imageName: "https://www.ngkntk.com/fileadmin/_processed_/csm_NGK_Laser_Iridium_Packaging_01_386x260_6d9e0f3e6a.png",
            categoryId: "1"
        ))
    }
    .padding()
}*/
