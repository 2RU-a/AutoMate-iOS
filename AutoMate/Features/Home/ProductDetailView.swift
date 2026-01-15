//
//  ProductDetailView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 1. დიდი სურათი
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 300)
                        
                        Image(systemName: product.imageName)
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // 2. ბრენდი და სახელი
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product.brand)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            
                            Text(product.name)
                                .font(.title)
                                .bold()
                        }
                        
                        // 3. ფასი
                        Text(product.formattedPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Divider()
                        
                        // 4. აღწერა
                        VStack(alignment: .leading, spacing: 10) {
                            Text("პროდუქტის აღწერა")
                                .font(.headline)
                            
                            Text(product.description)
                                .foregroundColor(.secondary)
                                .lineSpacing(5)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // 5. ფიქსირებული ღილაკი ქვემოთ
            VStack {
                Divider()
                Button {
                    // კალათაში დამატების ლოგიკა
                } label: {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("კალათაში დამატება")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(Color(.systemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
