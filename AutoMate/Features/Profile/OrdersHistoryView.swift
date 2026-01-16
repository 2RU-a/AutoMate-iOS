//
//  OrdersHistoryView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI

struct OrdersHistoryView: View {
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        List {
            if cartManager.orderHistory.isEmpty {
                Text("შეკვეთების ისტორია ცარიელია")
                    .foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(cartManager.orderHistory) { order in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("შეკვეთა #\(order.id)")
                                .fontWeight(.bold)
                            Spacer()
                            Text(order.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(5)
                        }
                        
                        Text(order.formattedDate)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        ForEach(order.items) { item in
                            Text(item.name)
                                .font(.footnote)
                        }
                        
                        HStack {
                            Text("ჯამი:")
                                .font(.subheadline)
                            Spacer()
                            Text(String(format: "%.2f ₾", order.totalPrice))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("შეკვეთები")
    }
}
