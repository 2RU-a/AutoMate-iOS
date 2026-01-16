//
//  Address.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation

struct Address: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String      // "სახლი"
    var city: String       // "თბილისი"
    var street: String     // "ჭავჭავაძის გამზ. 1"
    var isDefault: Bool    // ძირითადი მისამართი
    
    var fullAddress: String {
        "\(city), \(street)"
    }
}
