//
//  ServiceRecord.swift
//  AutoMate
//
//  Created by oto rurua on 20.01.26.
//

import Foundation
import FirebaseFirestore

struct ServiceRecord: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String        // მაგ: "ზეთის შეცვლა"
    var date: Date           // როდის ჩატარდა ან როდის არის დაგეგმილი
    var mileage: Int?        // რა გარბენზე
    var isCompleted: Bool    // ჩატარებულია თუ დაგეგმილი
    var note: String?        // დამატებითი შენიშვნა
    var cost: Double?
    var carName: String?
}
