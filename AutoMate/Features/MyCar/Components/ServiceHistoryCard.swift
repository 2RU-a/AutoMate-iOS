//
//  ServiceHistoryCard.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct ServiceHistoryCard: View {
    let service: ServiceRecord
    
    var body: some View {
        HStack(alignment: .top) {
            // მარცხენა მხარე: თარიღი
            VStack(spacing: 0) {
                Text(service.date.formatted(.dateTime.day().month()))
                    .font(.caption)
                    .bold()
                    .foregroundColor(.secondary)
                    .frame(width: 40)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(service.title)
                        .font(.headline)
                    Spacer()
                    

                    if let cost = service.cost {
                        Text(String(format: "%.0f ₾", cost))
                            .font(.callout)
                            .bold()
                            .foregroundColor(.green)
                            .padding(4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                HStack {
                    Image(systemName: "speedometer")
                    // შეცვლილია: mileageAtService -> mileage
                    Text("\(service.mileage ?? 0) km")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if let note = service.note {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
        }
    }
}
