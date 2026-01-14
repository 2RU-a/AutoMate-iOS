//
//  HomeView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // ფიქსირებული ჰედერი
            HomeHeaderView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. საძიებო ზოლი
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("მოძებნე ნაწილები ან სერვისები...")
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                    
                    // 2. კატეგორიები
                    VStack(alignment: .leading, spacing: 15) {
                        Text("კატეგორიები")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.categories) { category in
                                    // ✅ დავამატეთ ნავიგაცია
                                    NavigationLink(destination: CategoryProductsView(category: category)) {
                                        CategoryItemView(category: category)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 3. Offers (თუ გადაწყვეტ გამოჩენას, აქ ჩასვი)
                    if !viewModel.offers.isEmpty {
                        VStack(alignment: .leading) {
                            Text("სპეციალური შეთავაზებები")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.offers) { offer in
                                        OfferCard(offer: offer)
                                            .frame(width: 300)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemBackground))
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.loadData()
            }
        }
    }
}
