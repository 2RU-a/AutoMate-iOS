//
//  VehicleManagementView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct VehicleManagementView: View {
    @StateObject private var vehicleManager = VehicleManager.shared
    @State private var showAddCar = false
    
    var body: some View {
        List {
            if vehicleManager.cars.isEmpty {
                // ცარიელი მდგომარეობა (Empty State)
                VStack(spacing: 15) {
                    Image(systemName: "car.2.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("ავტომობილების სია ცარიელია")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Button(action: { showAddCar = true }) {
                        Text("დაამატე პირველი ავტომობილი")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
                .listRowBackground(Color.clear)
            } else {
                // ავტომობილების სია
                ForEach(vehicleManager.cars) { car in
                    HStack(spacing: 15) {
                        Image(systemName: "car.fill")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(car.make) \(car.model)")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                            
                            HStack {
                                Text(car.year)
                                Text("•")
                                Text(car.engine)
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                // ✅ აქ გასწორდა შეცდომა: indexSet-ის პირდაპირი გადაცემა
                .onDelete { indexSet in
                    vehicleManager.removeCar(at: indexSet)
                }
            }
        }
        .navigationTitle("მართვა")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddCar = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showAddCar) {
            AddCarView()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        VehicleManagementView()
    }
}
