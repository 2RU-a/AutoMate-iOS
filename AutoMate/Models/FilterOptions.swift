//
//  FilterOptions.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation

struct FilterOptions {
    var selectedBrands: Set<String> = []
    var minPrice: Double?
    var maxPrice: Double?
    var sortBy: SortOption = .newest
    
    var viscosity: String?
    var tireSeason: String?
    
    enum SortOption: String, CaseIterable {
        case newest = "უახლესი"
        case priceLowHigh = "ფასი: ზრდადი"
        case priceHighLow = "ფასი: კლებადი"
    }
}
