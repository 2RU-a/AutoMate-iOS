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
                emptyHistoryView
            } else {
                ForEach(cartManager.orderHistory) { order in
                    orderSection(order: order)
                }
            }
        }
        .navigationTitle("შეკვეთები")
        .listStyle(InsetGroupedListStyle())
    }
    
    // MARK: - Components
    
    private var emptyHistoryView: some View {
        VStack(spacing: 15) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            Text("შეკვეთების ისტორია ცარიელია")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .listRowBackground(Color.clear)
    }
    
    private func orderSection(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // ჰედერი: ID და სტატუსი
            HStack {
                Text("შეკვეთა #\(order.id)")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                
                Spacer()
                
                statusBadge(for: order.status)
            }
            
            Text(order.formattedDate)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Divider()
            
            // ნივთების სია შეკვეთაში
            VStack(alignment: .leading, spacing: 8) {
                ForEach(order.items) { item in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.blue)
                        
                        Text(item.name)
                            .font(.footnote)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(item.formattedPrice)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            // ფეხი: ჯამი
            HStack {
                Text("ჯამური ღირებულება")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.2f ₾", order.totalPrice))
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
    
    // სტატუსის ფერადი ბეიჯი
    private func statusBadge(for status: Order.OrderStatus) -> some View {
        Text(status.rawValue)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor(for: status).opacity(0.1))
            .foregroundColor(statusColor(for: status))
            .cornerRadius(6)
    }
    
    private func statusColor(for status: Order.OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}
