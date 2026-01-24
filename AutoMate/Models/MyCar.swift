//
//  MyCar.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//


import Foundation
import FirebaseFirestore

struct MyCar: Identifiable, Codable {
    @DocumentID var id: String? // Firebase თავად მიანიჭებს უნიკალურ ID-ს
    var make: String
    var model: String
    var year: String
    var engine: String
    var vinCode: String?
    var services: [ServiceRecord]?
    
    var fullName: String {
        "\(make) \(model) (\(year)"
    }
}
