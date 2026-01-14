//
//  CarInfoCard.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct CarInfoCard: View {
    let car: Car
    @State private var showLargeQR = false // შიდა მდგომარეობა Sheet-ისთვის
    
    // მანქანის მონაცემების JSON-ად ქცევა QR-ისთვის
    var carDataString: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // ლამაზად რომ გამოჩნდეს სკანირებისას
        if let data = try? encoder.encode(car),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return car.vin // თუ ვერ დააკონვერტირა, მარტო VIN ჩაწეროს
    }
    
    var body: some View {
        HStack(alignment: .top) {
            // მარცხენა მხარე: ინფორმაცია
            VStack(alignment: .leading, spacing: 8) {
                
                // 1. ბრენდი
                Text(car.brand.uppercased())
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // 2. მოდელი და წელი
                Text("\(car.model) • \(String(car.year))")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                
                // 3. VIN კოდი
                VStack(alignment: .leading, spacing: 2) {
                    Text("VIN CODE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(2)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(car.vin)
                        .font(.caption2)
                        .monospaced()
                        .padding(10)
                        .background(.black.opacity(0.2))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                }
                
                // 4. გარბენი
                HStack(spacing: 4) {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                    Text(car.formattedMileage)
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.green)
                .padding(.top, 4)
            }
            
            Spacer()
            
            // მარჯვენა მხარე: გენერირებული QR კოდი
            VStack {
                // ვიყენებთ ჩვენს Helper-ს
                Image(uiImage: QRCodeGenerator.generate(from: carDataString))
                    .resizable()
                    .interpolation(.none) // პიქსელები არ გაწელოს (მნიშვნელოვანია QR-ისთვის)
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(6) // თეთრი ჩარჩო რომ ჰქონდეს
                    .background(Color.white)
                    .cornerRadius(12)
                    // ჟესტი, რომელიც გადაფარავს NavigationLink-ს
                    .onTapGesture {
                        showLargeQR = true
                    }
                
                Spacer()
            }
        }
        .padding(20)
        .frame(height: 180)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.black.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        
        // 📢 Sheet - დიდი QR კოდის საჩვენებლად
        .sheet(isPresented: $showLargeQR) {
            QRCodeSheetView(car: car, qrData: carDataString)
                .presentationDetents([.medium]) // ნახევარზე ამოვიდეს
                .presentationDragIndicator(.visible)
        }
    }
}

// ცალკე View დიდი QR-ისთვის (Sheet-ის შიგთავსი)
struct QRCodeSheetView: View {
    let car: Car
    let qrData: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("დაასკანირეთ სერვისისთვის")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            Text(car.fullName)
                .font(.title2)
                .bold()
            
            Image(uiImage: QRCodeGenerator.generate(from: qrData))
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            
            Text(car.vin)
                .monospaced()
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    CarInfoCard(car: Car(id: "1", brand: "Mercedes-Benz", model: "G-Class", year: 2023, vin: "WDB1234567890", currentMileage: 12500, mileageUnit: .kilometers))
        .padding()
}
