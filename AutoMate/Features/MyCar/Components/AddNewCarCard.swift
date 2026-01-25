//
//  AddNewCarCard.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct AddNewCarCard: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            
            Text("დაამატე მანქანა")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("ახალი მანქანის რეგისტრაცია")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .foregroundColor(Color.blue.opacity(0.3))
        )
        .cornerRadius(20)
    }
}

//#Preview {
//    AddNewCarCard()
//        .padding()
//}
