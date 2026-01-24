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
    
    var body: some View {
        List {
            if vehicleManager.allCompletedServices.isEmpty {
                // თუ ისტორია ცარიელია, გამოჩნდება ლამაზი Placeholder
                ContentUnavailableView(
                    "ისტორია ცარიელია",
                    systemImage: "wrench.and.screwdriver",
                    description: Text("თქვენ ჯერ არ გაქვთ დასრულებული სერვისები.")
                )
            } else {
                ForEach(vehicleManager.allCompletedServices) { service in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(service.title)
                                .fontWeight(.bold)
                            Spacer()
                            Text(service.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // თუ გარბენი მითითებულია, გამოაჩენს
                        if let mileage = service.mileage {
                            Text("გარბენი: \(mileage) კმ")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        // თუ ჩანაწერი/ნოუთი არსებობს, გამოაჩენს
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
        .navigationTitle("სერვისების ისტორია")
        .navigationBarTitleDisplayMode(.inline)
    }
}
