//
//  CategoryProductsView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct CategoryProductsView: View {
    let category: Category
    
    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text("\(category.name)-ს პროდუქტები მალე დაემატება")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
