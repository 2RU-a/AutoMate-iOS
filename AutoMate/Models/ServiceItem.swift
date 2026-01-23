//
//  ServiceItem.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation


struct ServiceItem: Identifiable, Codable {
    var id: String
    let carId: String
    let title: String          // მაგ: "ზეთის შეცვლა"
    let date: Date
    let mileageAtService: Int  // მაგ: 150,000
    let cost: Double?          // მაგ: 120.00
    let note: String?
    
    // შემდეგი სერვისის პროგნოზი (შენი ლოგიკით - Optional)
    var nextDueMileage: Int?
    var nextDueDate: Date?
}
