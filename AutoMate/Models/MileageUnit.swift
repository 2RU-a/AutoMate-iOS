//
//  MileageUnit.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

enum MileageUnit: String, Codable, CaseIterable {
    case kilometers = "km"
    case miles = "mi"
    
    // დამხმარე თვისება UI-სთვის
    var title: String {
        switch self {
        case .kilometers: return "კმ"
        case .miles: return "მილი"
        }
    }
}
