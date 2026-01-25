//
//  MyCarView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MyCarView: View {
    @StateObject private var vehicleManager = VehicleManager.shared
    @StateObject private var authManager = AuthManager.shared
    
    @State private var selectedCarID: String?
    @State private var showAddService = false
    @State private var showAddCar = false
    
    // MARK: - Computed Properties
    private var currentServices: [ServiceRecord] {
        // ვამოწმებთ, რომ ID არ იყოს nil და არ იყოს პლეისჰოლდერის ID
        guard let id = selectedCarID, id != "add_new_car_placeholder" else { return [] }
        return vehicleManager.services[id] ?? []
    }
    
    private var maintenanceDue: ServiceRecord? {
        currentServices.first { !$0.isCompleted && $0.date < Date() }
    }
    
    private var upcomingServices: [ServiceRecord] {
        currentServices.filter { !$0.isCompleted && $0.date >= Date() }
            .sorted(by: { $0.date < $1.date })
    }
    
    private var completedServices: [ServiceRecord] {
        guard let id = selectedCarID else { return [] }
        return currentServices.filter { $0.isCompleted }
            .sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        NavigationStack {
            Group {
                if authManager.isAnonymous {
                    GuestPlaceholderView(
                        title: "თქვენი ავტო-ფარეხი",
                        message: "მანქანების დასამატებლად და სერვისების სამართავად საჭიროა გაიაროთ რეგისტრაცია"
                    )
                } else {
                    mainDashboardContent
                }
            }
            .navigationTitle("ჩემი ავტომობილი")
            .background(Color(.systemGroupedBackground))
            .onAppear {
                if selectedCarID == nil {
                    selectedCarID = vehicleManager.cars.first?.id
                }
            }
            .sheet(isPresented: $showAddCar) {
                AddCarView(carToEdit: nil)
            }
        }
    }
    
    // MARK: - Main Content View
    private var mainDashboardContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 25) {
                headerCarouselSection
            
                VStack(spacing: 25) {
                    serviceQuickActionSection
                    
                    if let service = maintenanceDue {
                        maintenanceDueSection(for: service)
                    }
                    
                    // დაგეგმილი სერვისები
                    if !upcomingServices.isEmpty {
                        upcomingServicesSection(services: upcomingServices)
                    } else if !vehicleManager.cars.isEmpty && completedServices.isEmpty {
                        noServicesSection
                    }
                    
                    // სერვისების ისტორია
                    if !completedServices.isEmpty {
                        historySection(services: completedServices)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Sections
    
    private var headerCarouselSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if vehicleManager.cars.isEmpty {
                    addCarPlaceholder
                        .containerRelativeFrame(.horizontal)
                } else {
                    ForEach(vehicleManager.cars) { car in
                        CarDashboardCard(car: car)
                            .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 30)
                            .id(car.id)
                    }
                    addCarPlaceholder
                        .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 30)
                        .id("add_new_car_placeholder")
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $selectedCarID)
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 20, for: .scrollContent)
    }

    private var addCarPlaceholder: some View {
        Button(action: { showAddCar = true }) {
            VStack(spacing: 15) {
                Image(systemName: "plus.circle.fill").font(.system(size: 60))
                Text("ახალი ავტომობილის დამატება").font(.headline)
            }
            .frame(maxWidth: .infinity).frame(height: 200)
            .background(RoundedRectangle(cornerRadius: 25).stroke(style: StrokeStyle(lineWidth: 2, dash: [10])).foregroundColor(.blue.opacity(0.5)).background(Color.blue.opacity(0.05)))
            .cornerRadius(25)
        }
    }

    private var serviceQuickActionSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: {
                // დამატებითი დაცვა: მხოლოდ მაშინ ვხსნით, თუ რეალური მანქანაა არჩეული
                if selectedCarID != nil && selectedCarID != "add_new_car_placeholder" {
                    showAddService = true
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("სერვისის დაჯავშნა").font(.headline)
                        Text("ჩაინიშნე მომავალი ვიზიტი").font(.subheadline).opacity(0.8)
                    }
                    Spacer()
                    Image(systemName: "calendar.badge.plus").font(.title)
                }
                .padding().background(Color.blue).foregroundColor(.white).cornerRadius(16)
            }
            // 👇 აქ არის მთავარი ცვლილება: პირობების გაერთიანება
            .disabled(vehicleManager.cars.isEmpty || selectedCarID == nil || selectedCarID == "add_new_car_placeholder")
            .opacity((vehicleManager.cars.isEmpty || selectedCarID == nil || selectedCarID == "add_new_car_placeholder") ? 0.6 : 1.0)
            
            // ინფორმაციული ტექსტები
            if vehicleManager.cars.isEmpty {
                Text("სერვისის დასაჯავშნად ჯერ დაამატეთ ავტომობილი")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 5)
            } else if selectedCarID == nil || selectedCarID == "add_new_car_placeholder" {
                Text("აირჩიეთ კონკრეტული ავტომობილი სერვისის დასაჯავშნად")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.leading, 5)
            }
        }
        .sheet(isPresented: $showAddService) {
            if let carId = selectedCarID, carId != "add_new_car_placeholder" {
                AddServiceView(carId: carId)
            }
        }
    }

    private func upcomingServicesSection(services: [ServiceRecord]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("დაგეგმილი სერვისები").font(.title3).fontWeight(.bold)
            VStack(spacing: 1) {
                ForEach(services) { service in
                    NavigationLink(destination: ServiceDetailView(service: service, carId: selectedCarID ?? "")) {
                        serviceRow(title: service.title, date: service.date.formatted(date: .long, time: .omitted), icon: "calendar.badge.clock")
                    }
                    .buttonStyle(PlainButtonStyle())
                    if service.id != services.last?.id { Divider().padding(.leading, 50) }
                }
            }
            .background(Color(.secondarySystemGroupedBackground)).cornerRadius(12)
        }
    }
    
    private func historySection(services: [ServiceRecord]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("სერვისების ისტორია").font(.title3).fontWeight(.bold)
            VStack(spacing: 1) {
                ForEach(services) { service in
                    NavigationLink(destination: ServiceDetailView(service: service, carId: selectedCarID ?? "")) {
                        serviceRow(title: service.title, date: service.date.formatted(date: .long, time: .omitted), icon: "checkmark.circle.fill", iconColor: .green)
                    }
                    .buttonStyle(PlainButtonStyle())
                    if service.id != services.last?.id { Divider().padding(.leading, 50) }
                }
            }
            .background(Color(.secondarySystemGroupedBackground)).cornerRadius(12)
        }
    }

    private func serviceRow(title: String, date: String, icon: String, iconColor: Color = .blue) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon).foregroundColor(iconColor).font(.title3).frame(width: 30)
            VStack(alignment: .leading) {
                Text(title).fontWeight(.medium)
                Text(date).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding()
    }

    private func maintenanceDueSection(for service: ServiceRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ყურადღება მისაქცევი").font(.title3).fontWeight(.bold)
            HStack {
                Circle().fill(.red).frame(width: 10, height: 10)
                VStack(alignment: .leading) {
                    Text(service.title).fontWeight(.semibold)
                    Text("ვადა გადაცილებულია: \(service.date.formatted(date: .abbreviated, time: .omitted))").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            }
            .padding().background(Color(.secondarySystemGroupedBackground)).cornerRadius(12)
        }
    }

    private var noServicesSection: some View {
        Text("დაგეგმილი სერვისები არ გაქვთ").font(.subheadline).foregroundColor(.secondary).frame(maxWidth: .infinity).padding()
    }
}

// MARK: - CarDashboardCard
struct CarDashboardCard: View {
    let car: MyCar
    @State private var showQRSheet = false
    private let context = CIContext()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
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
                        Text(vin).font(.system(.caption, design: .monospaced)).fontWeight(.bold).padding(8).background(Color.white.opacity(0.2)).foregroundColor(.white).cornerRadius(8)
                    }
                }
                Spacer()
                if let vin = car.vinCode, !vin.isEmpty, let qrImage = generateQRCode(from: vin) {
                    Button { showQRSheet = true } label: {
                        VStack(spacing: 8) {
                            Image(uiImage: qrImage).interpolation(.none).resizable().frame(width: 75, height: 75).padding(6).background(Color.white).cornerRadius(12)
                            Text("QR კოდი").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(LinearGradient(colors: [.blue, .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(25).shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
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
            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) { return UIImage(cgImage: cgimg) }
        }
        return nil
    }
}

// MARK: - QRDetailView
struct QRDetailView: View {
    let car: MyCar
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Capsule().fill(Color.secondary.opacity(0.3)).frame(width: 40, height: 6).padding(.top, 12)
            Text("\(car.make) \(car.model)").font(.title2).fontWeight(.bold)
            
            if let vin = car.vinCode, !vin.isEmpty, let qrImage = generateQRCode(from: vin) {
                VStack(spacing: 20) {
                    Image(uiImage: qrImage).interpolation(.none).resizable().frame(width: 250, height: 250).padding().background(Color.white).cornerRadius(20).shadow(color: .black.opacity(0.1), radius: 10)
                    Text(vin).font(.system(.title3, design: .monospaced)).fontWeight(.bold)
                }
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
            if let cgimg = CIContext().createCGImage(transformedImage, from: transformedImage.extent) { return UIImage(cgImage: cgimg) }
        }
        return nil
    }
}
