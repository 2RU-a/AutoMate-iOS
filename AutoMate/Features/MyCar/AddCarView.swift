//
//  AddCarView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct AddCarView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "car.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("მანქანის დამატება")
                    .font(.title2)
                    .bold()
                
                Text("აქ იქნება ფორმა VIN კოდის და მონაცემების შესაყვანად")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("ახალი მანქანა")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("გაუქმება") {
                        dismiss()
                    }
                }
            }
        }
    }
}
