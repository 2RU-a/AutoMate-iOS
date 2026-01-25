//
//  Category.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

struct Category: Identifiable, Codable {
    var id: String
    let name_ka: String
    let name_en: String
    let iconName: String
    
    // ეს თვისება ავტომატურად აირჩევს შესაბამის სახელს
    var displayName: String {
        return LocalizationManager.shared.selectedLanguage == "ka" ? name_ka : name_en
    }
}

