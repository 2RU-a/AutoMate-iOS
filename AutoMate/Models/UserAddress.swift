//
//  Address.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import FirebaseFirestore // აუცილებელია @DocumentID-სთვის

struct UserAddress: Identifiable, Codable, Equatable {
    @DocumentID var id: String? //  Firebase თავად მიანიჭებს უნიკალურ ID-ს
    var title: String
    var city: String
    var street: String
    var isDefault: Bool
    
    var fullAddress: String {
        "\(city), \(street)"
    }
}
