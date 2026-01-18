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
    
    // Alert-ის მართვისთვის საჭირო State-ები
    @State private var showDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?
    
    var body: some View {
        List {
            if vehicleManager.cars.isEmpty {
                emptyStateView
            } else {
                ForEach(vehicleManager.cars) { car in
                    carRowView(car: car)
                }
                .onDelete { indexSet in
                    // პირდაპირ კი არ ვშლით, ვიმახსოვრებთ ინდექსს და ვაჩვენებთ Alert-ს
                    self.indexSetToDelete = indexSet
                    self.showDeleteAlert = true
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
        // წაშლის დადასტურების Alert
        .alert("ავტომობილის წაშლა", isPresented: $showDeleteAlert) {
            Button("წაშლა", role: .destructive) {
                if let indexSet = indexSetToDelete {
                    vehicleManager.removeCar(at: indexSet)
                }
            }
            Button("გაუქმება", role: .cancel) {
                indexSetToDelete = nil
            }
        } message: {
            Text("ნამდვილად გსურთ ამ ავტომობილის წაშლა? მონაცემების აღდგენა შეუძლებელი იქნება.")
        }
    }
    
    // MARK: - კომპონენტები
    
    private var emptyStateView: some View {
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
    }
    
    private func carRowView(car: MyCar) -> some View {
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
}

// MARK: - Preview
#Preview {
    NavigationStack {
        VehicleManagementView()
    }
}
