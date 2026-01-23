//
//  Order.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let date: Date
    let items: [Product]
    let totalPrice: Double
    var status: OrderStatus
    
    enum OrderStatus: String, Codable {
        case pending = "მუშავდება"
        case processing = "მზადდება"
        case delivered = "მოტანილია"
        case cancelled = "გაუქმებულია"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ka_GE")
        return formatter.string(from: date)
    }
}
