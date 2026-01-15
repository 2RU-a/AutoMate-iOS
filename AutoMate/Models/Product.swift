//
//  Product.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let brand: String
    let description: String
    let price: Double
    let imageName: String
    let categoryId: String
    
    var formattedPrice: String {
        String(format: "%.2f ₾", price)
    }
}
