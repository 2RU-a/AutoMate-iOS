//
//  MyCar.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation

struct MyCar: Identifiable, Codable, Equatable {
    var id = UUID()
    var make: String       // მაგ: BMW
    var model: String      // მაგ: X5
    var year: String       // მაგ: 2018
    var engine: String     // მაგ: 3.0 B58
    var vinCode: String?   // ვინ კოდი (არასავალდებულო)
    
    var fullName: String {
        "\(make) \(model) (\(year))"
    }
}


