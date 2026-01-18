//
//  MyCarView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins


struct MyCarView: View {
    @StateObject private var vehicleManager = VehicleManager.shared
    
    var body: some View {
        NavigationStack {
            // ✅ ScrollView-ს ვამატებთ ჰორიზონტალურ სქროლს და Snapping ქცევას
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) { // ქარდებს შორის მცირე დაშორება
                    if vehicleManager.cars.isEmpty {
                        emptyState
                            .containerRelativeFrame(.horizontal)
                    } else {
                        ForEach(vehicleManager.cars) { car in
                            CarDashboardCard(car: car)
                                // ✅ ეს ხაზი აცენტრებს ქარდს და ტოვებს გვერდებზე სივრცეს
                                .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 30)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 20, for: .scrollContent) // ✅ ამატებს სივრცეს ეკრანის კიდეებთან
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.circle")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            Text("ავტომობილი არ არის დამატებული")
                .font(.headline)
        }
    }
}

struct CarDashboardCard: View {
    let car: MyCar
    @State private var showQRSheet = false
    private let context = CIContext()
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(car.make).font(.title).fontWeight(.bold).foregroundColor(.white)
                    Text(car.model).font(.title2).foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        Label(car.engine, systemImage: "engine.combustion")
                        Text("|")
                        Text(car.year)
                    }
                    .font(.subheadline).foregroundColor(.white.opacity(0.8))
                    
                    if let vin = car.vinCode, !vin.isEmpty {
                        Text(vin)
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold).padding(8)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white).cornerRadius(8)
                    }
                }
                Spacer()
                
                if let vin = car.vinCode, !vin.isEmpty, let qrImage = generateQRCode(from: vin) {
                    Button { showQRSheet = true } label: {
                        VStack(spacing: 8) {
                            Image(uiImage: qrImage)
                                .interpolation(.none).resizable()
                                .frame(width: 75, height: 75)
                                .padding(6).background(Color.white).cornerRadius(12)
                            Text("დააჭირე სანახავად").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(LinearGradient(colors: [.blue, .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .sheet(isPresented: $showQRSheet) {
            QRDetailView(car: car)
                .presentationDetents([.fraction(0.75)])
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

// QR კოდის გადიდების გვერდი
struct QRDetailView: View {
    let car: MyCar
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Capsule().fill(Color.secondary.opacity(0.3)).frame(width: 40, height: 6).padding(.top, 12)
            Text(car.fullName).font(.title2).fontWeight(.bold)
            
            if let vin = car.vinCode, let qrImage = generateQRCode(from: vin) {
                Image(uiImage: qrImage)
                    .interpolation(.none).resizable()
                    .frame(width: 250, height: 250)
                    .padding().background(Color.white).cornerRadius(20).shadow(radius: 10)
                
                Text(vin).font(.system(.title3, design: .monospaced)).fontWeight(.bold)
            }
            Spacer()
            Button("დახურვა") { dismiss() }.buttonStyle(.borderedProminent).padding(.bottom, 20)
        }
        .padding()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgimg = CIContext().createCGImage(transformedImage, from: transformedImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}
