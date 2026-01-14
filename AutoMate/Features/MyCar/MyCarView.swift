//
//  MyCarView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct MyCarView: View {
    @StateObject private var viewModel = MyCarViewModel()
    @State private var showAddCarSheet = false
    
    // წაშლისთვის საჭირო ცვლადები
    @State private var showDeleteConfirmation = false
    @State private var carToDelete: Car? // რომ დავიმახსოვროთ, რომელი უნდა წაიშალოს
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView("იტვირთება...")
            } else if let error = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text(error)
                }
            } else {
                VStack {
                    TabView {
                        // 1. არსებული მანქანები
                        ForEach(viewModel.cars) { car in
                            NavigationLink(destination: CarDetailView(car: car)) {
                                CarInfoCard(car: car)
                                    .padding(.horizontal)
                                    // კონტექსტური მენიუ (Long Press)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            carToDelete = car
                                            showDeleteConfirmation = true
                                        } label: {
                                            Label("მანქანის წაშლა", systemImage: "trash")
                                        }
                                        
                                        // აქ სხვა ღილაკების დამატებაც შეიძლება (მაგ: რედაქტირება)
//                                        Button {
//                                            // Edit Logic
//                                        } label: {
//                                            Label("რედაქტირება", systemImage: "pencil")
//                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // 2. დამატების ღილაკი
                        Button {
                            showAddCarSheet = true
                        } label: {
                            AddNewCarCard()
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 280)
                    
                    // მინიშნება მომხმარებლისთვის
//                    if !viewModel.cars.isEmpty {
//                        Text("ხანგრძლივად დააჭირეთ ბარათს რედაქტირებისთვის")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                            .padding(.top, 5)
//                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
        }
        //.navigationTitle("ჩემი გარაჟი")
        .task {
            await viewModel.loadCars()
        }
        .refreshable {
            await viewModel.loadCars()
        }
        .sheet(isPresented: $showAddCarSheet) {
            AddCarView()
        }
        // დასტურის დიალოგი

        .alert("ნამდვილად გსურთ წაშლა?", isPresented: $showDeleteConfirmation) {
            Button("წაშლა", role: .destructive) {
                if let car = carToDelete {
                    Task {
                        await viewModel.deleteCar(car)
                    }
                }
            }
            Button("გაუქმება", role: .cancel) {
                carToDelete = nil
            }
        } message: {
            Text("ეს ქმედება წაშლის მანქანას და მის სერვისების ისტორიას.")
        }
    }
}

#Preview {
    NavigationStack {
        MyCarView()
    }
}
