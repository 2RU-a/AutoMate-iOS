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
            // პროდუქტის სურათი (პატარა)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 70, height: 70)
                
                Image(systemName: product.imageName)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            // ინფორმაცია
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
