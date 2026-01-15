//
//  MockHomeService.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation
import SwiftUI

final class MockHomeService: HomeServiceProtocol, Sendable {
    
    func fetchOffers() async throws -> [Offer] {
        try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
        return [
            Offer(id: "1", title: "ზამთრის საბურავები", subtitle: "შეიძინე 20% ფასდაკლებით", colorCode: "blue"),
            Offer(id: "2", title: "უფასო დიაგნოსტიკა", subtitle: "Tegeta Motors-ისგან", colorCode: "orange"),
            Offer(id: "3", title: "ზეთის შეცვლა", subtitle: "Castrol + ფილტრი საჩუქრად", colorCode: "green")
        ]
    }
    
    func fetchCategories() async throws -> [Category] {
        try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
        return [
            Category(id: "1", name: "ძრავი", iconName: "engine.combustion"),
            Category(id: "2", name: "სავალი ნაწილი", iconName: "car.side.fill"),
            Category(id: "3", name: "ელექტროობა", iconName: "bolt.car"),
            Category(id: "4", name: "საბურავები", iconName: "circle.circle"),
            Category(id: "5", name: "ზეთები", iconName: "drop.fill"),
            Category(id: "6", name: "აქსესუარები", iconName: "steeringwheel")
        ]
    }
    
    func fetchProducts(for categoryId: String) async throws -> [Product] {
        try? await Task.sleep(for: .seconds(0.5))
        
        // მაგალითისთვის მხოლოდ "ზეთების" (id: "5") პროდუქტები
        return [
            Product(id: "101", name: "Edge 5W-30", brand: "Castrol", description: "სინთეტიკური", price: 145.00, imageName: "drop.fill", categoryId: "5")
        ]
    }
}
