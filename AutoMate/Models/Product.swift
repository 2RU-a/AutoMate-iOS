//
//  Product.swift
//  AutoMate
//
//  Created by oto rurua on 15.01.26.
//

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var brand: String
    var description: String
    var price: Double
    var oldPrice: Double?
    var isHotDeal: Bool?
    var imageName: String
    var categoryId: String
    
    var formattedPrice: String {
        String(format: "%.2f ₾", price)
    }
    
    var formattedOldPrice: String {
        oldPrice != nil ? String(format: "%.2f ₾", oldPrice!) : ""
    }
}
