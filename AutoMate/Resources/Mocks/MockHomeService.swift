//
//  MockHomeService.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

final class MockHomeService: HomeServiceProtocol, Sendable {
    func fetchOffers() async throws -> [Offer] {
        try? await Task.sleep(for: .seconds(0.3))
        return [
            Offer(id: "1", title: "ზამთრის აქცია", subtitle: "20% ფასდაკლება", colorCode: "blue"),
            Offer(id: "2", title: "უფასო დიაგნოსტიკა", subtitle: "Tegeta-სგან", colorCode: "orange")
        ]
    }
    
    func fetchCategories() async throws -> [Category] {
        try? await Task.sleep(for: .seconds(0.3))
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
        return Product.sampleData.filter { $0.categoryId == categoryId }
    }
    
    func fetchAllProducts() async throws -> [Product] {
        return Product.sampleData
    }
}
