//
//  Car.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation

struct Car: Identifiable, Codable {
    var id: String
    let brand: String
    let model: String
    let year: Int
    let vin: String
    var currentMileage: Int
    var mileageUnit: MileageUnit
    
    var fullName: String {
        "\(brand) \(model) (\(year))"
    }
    
    var formattedMileage: String {
        "\(currentMileage) \(mileageUnit.title)"
    }
}
