//
//  LanguageView.swift
//  AutoMate
//
//  Created by oto rurua on 25.01.26.
//

import Foundation
import SwiftUI

struct LanguageView: View {
    @StateObject private var langManager = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            languageRow(title: "🇬🇪 ქართული", code: "ka")
            languageRow(title: "🇬🇧 English", code: "en")
        }
        .navigationTitle(langManager.t("language"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func languageRow(title: String, code: String) -> some View {
        Button(action: {
            langManager.selectedLanguage = code
            dismiss()
        }) {
            HStack {
                Text(title)
                Spacer()
                if langManager.selectedLanguage == code {
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

