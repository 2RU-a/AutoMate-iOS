//
//  CategoryItemView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct CategoryItemView: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 12) {
            // ხატულის სექცია წრეში
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: category.iconName)
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            
            // კატეგორიის დასახელება
            Text(category.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

//#Preview {
//    CategoryItemView(category: Category(id: "1", name: "ძრავი", iconName: ""))
//        .frame(width: 100)
//        .padding()
//    
//}
