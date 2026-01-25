//
//  Category.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation

struct Category: Identifiable, Codable {
    var id: String
    let name: String
    let iconName: String
    
    var displayName: String {
        let currentLang = UserDefaults.standard.string(forKey: "selected_language") ?? "ka"
        
        // თუ ენა ინგლისურია, ვცდილობთ ვთარგმნოთ სახელი LocalizationManager-ის მეშვეობით
        if currentLang == "en" {
            return LocalizationManager.shared.t(self.name)
        }
        return self.name
    }
}

