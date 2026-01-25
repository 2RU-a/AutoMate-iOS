//
//  ServiceHistoryView.swift
//  AutoMate
//
//  Created by oto rurua on 24.01.26.
//

import Foundation
import SwiftUI

struct ServiceHistoryView: View {
    @StateObject private var vehicleManager = VehicleManager.shared
    @StateObject private var lang = LocalizationManager.shared
    
    var body: some View {
        List {
            if vehicleManager.allCompletedServices.isEmpty {
                ContentUnavailableView(
                    lang.t("history_empty"), // "ისტორია ცარიელია"
                    systemImage: "wrench.and.screwdriver",
                    description: Text(lang.t("history_empty_desc")) // "თქვენ ჯერ არ გაქვთ..."
                )
            } else {
                ForEach(vehicleManager.allCompletedServices) { service in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(service.title)
                                    .fontWeight(.bold)
                                
                                // 👇 გამოვაჩენთ მანქანის სახელს
                                if let carName = service.carName {
                                    Text(carName)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            Spacer()
                            Text(service.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let mileage = service.mileage {
                            Text("\(lang.t("mileage")): \(mileage) \(lang.t("km"))") // "გარბენი: ... კმ"
                                .font(.subheadline)
                        }
                        
                        if let note = service.note, !note.isEmpty {
                            Text(note)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(lang.t("service_history"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
