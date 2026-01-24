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
            // 1. სურათის ზონა
            ZStack(alignment: .topTrailing) {
                Color(.secondarySystemBackground)
                
                Group {
                    // შევცვალეთ ლოგიკა: ვცდილობთ URL-ის შექმნას და AsyncImage-ს გამოყენებას
                    if let url = URL(string: product.imageName), product.imageName.hasPrefix("http") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 140)
                                    .clipped()
                            case .failure:
                                fallbackImage
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        // თუ არ არის URL, ვცდილობთ გამოვიყენოთ როგორც Asset Image (ლოკალური)
                        Image(product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .onAppear {
                                // თუ ფოტო მაინც არ ჩანს, აქ fallbackImage გამოჩნდება
                            }
                    }
                }
                
                if product.isHotDeal {
                    saleBadge
                }
                
                // ფავორიტის ღილაკი
                favoriteButtonSection
            }
            .frame(height: 140)
            .cornerRadius(12)
            
            // 2. ინფორმაციის ზონა
            infoSection
            
            Spacer(minLength: 0)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: 235)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - კომპონენტები
    
    private var infoSection: some View {
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
                .frame(height: 34, alignment: .topLeading)
            
            Text(product.formattedPrice)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 2)
        }
        .padding(.top, 8)
        .padding(.horizontal, 4)
    }
    
    private var saleBadge: some View {
        Text("HOT")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.red)
            .cornerRadius(4)
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

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
        VStack {
            Image(systemName: "photo")
                .font(.system(size: 30))
                .foregroundColor(.gray.opacity(0.4))
            Text("სურათი მიუწვდომელია")
                .font(.system(size: 8))
                .foregroundColor(.gray.opacity(0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//#Preview {
//    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
//        ProductCard(product: Product(
//            id: "1",
//            name: "Edge 5W-30",
//            brand: "Castrol",
//            description: "Premium oil",
//            price: 145.0,
//            isHotDeal: true, imageName: "drop.fill",
//            categoryId: "5"
//        ))
//        
//        ProductCard(product: Product(
//            id: "2",
//            name: "ამნთები სანთელი",
//            brand: "NGK",
//            description: "Iridium",
//            price: 25.0,
//            isHotDeal: false, imageName: "https://www.ngkntk.com/fileadmin/_processed_/csm_NGK_Laser_Iridium_Packaging_01_386x260_6d9e0f3e6a.png",
//            categoryId: "1"
//        ))
//    }
//    .padding()
//}
