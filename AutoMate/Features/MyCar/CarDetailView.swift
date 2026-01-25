//
//  CarDetailView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct CarDetailView: View {
    let car: Car
    @StateObject private var viewModel: CarDetailViewModel
    
    init(car: Car) {
        self.car = car
        // ViewModel-ის ინიციალიზაცია კონკრეტული მანქანის ID-ით
        _viewModel = StateObject(wrappedValue: CarDetailViewModel(carId: car.id))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // სათაური
                HStack {
                    Text("სერვისების ისტორია")
                        .font(.title2)
                        .bold()
                    Spacer()
                    // აქ მომავალში იქნება ღილაკი "დამატება" (+)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // შიგთავსი
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if viewModel.services.isEmpty {
                    ContentUnavailableView("ისტორია ცარიელია", systemImage: "doc.text", description: Text("ამ მანქანაზე სერვისები არ მოიძებნა"))
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.services) { service in
                            ServiceHistoryCard(service: service)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(car.brand + " " + car.model)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadServices()
        }
    }
}

//#Preview {
//    NavigationStack {
//        // Mock მონაცემებით ტესტირება
//        CarDetailView(car: Car(id: "1", brand: "Toyota", model: "Prius", year: 2017, vin: "123", currentMileage: 100000, mileageUnit: .kilometers))
//    }
//}
