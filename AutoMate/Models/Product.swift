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
    let name: String
    let brand: String
    let description: String
    let price: Double
    let imageName: String
    let categoryId: String
    
    //  გამოთვლადი ცვლადი
    var formattedPrice: String {
        return String(format: "%.2f ₾", price)
    } // 👈 ეს ფრჩხილი აკლდა!

    // სატესტო მონაცემები
    static var sampleData: [Product] = [
        // 1. ძრავი
        Product(id: "1", name: "ამნთები სანთელი TEST", brand: "NGK", description: "ირიდიუმი", price: 25.0, imageName: "engine.combustion", categoryId: "1"),
        Product(id: "2", name: "წყლის ტუმბო TEST", brand: "Bosch", description: "გამძლე", price: 120.0, imageName: "engine.combustion", categoryId: "1"),
        // 2. სავალი ნაწილი
        Product(id: "3", name: "ამორტიზატორი TEST", brand: "KYB", description: "წინა", price: 185.0, imageName: "car.side.fill", categoryId: "2"),
        Product(id: "4", name: "ხუნდები TEST", brand: "Brembo", description: "კერამიკა", price: 95.0, imageName: "car.side.fill", categoryId: "2"),
        // 3. ელექტროობა
        Product(id: "5", name: "აკუმულატორი TEST", brand: "Varta", description: "75Ah", price: 320.0, imageName: "bolt.car", categoryId: "3"),
        // 4. საბურავები
        Product(id: "7", name: "ზამთრის საბურავი TEST", brand: "Michelin", description: "205/55 R16", price: 240.0, imageName: "circle.circle", categoryId: "4"),
        Product(id: "8", name: "ზაფხულის საბურავი TEST", brand: "Bridgestone", description: "225/45 R17", price: 210.0, imageName: "circle.circle", categoryId: "4"),
        // 5. ზეთები
        Product(id: "9", name: "ძრავის ზეთი TEST 5W-30", brand: "Castrol", description: "Edge", price: 145.0, imageName: "drop.fill", categoryId: "5"),
        Product(id: "10", name: "ძრავის ზეთი TEST 10W-40", brand: "Shell", description: "Helix", price: 85.0, imageName: "drop.fill", categoryId: "5"),
        // 6. აქსესუარები
        Product(id: "12", name: "საწმენდები TEST", brand: "Bosch", description: "Aerotwin", price: 65.0, imageName: "steeringwheel", categoryId: "6")
    ]
}
