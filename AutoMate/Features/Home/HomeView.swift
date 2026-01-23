//
//  HomeView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    // MARK: - State Properties
    @State private var searchText = ""
    @State private var selectedOffer: Offer? = nil // სპეციალური შეთავაზების ასარჩევად
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {

            HomeHeaderView()
           
            customSearchBar
                .padding(.vertical, 10)
            
            ScrollView {
                if !searchText.isEmpty {
                    searchResultsGrid
                } else {
                    mainHomeContent
                }
            }
        }
        .background(Color(.systemBackground))
        .sheet(item: $selectedOffer) { offer in
            OfferDetailSheet(offer: offer)
        }
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.loadData()
            }
        }
    }
    
    // MARK: - Computed Property (ფილტრაციის ლოგიკა მხოლოდ Hot Deals-ზე)
    private var filteredProducts: [Product] {
        viewModel.hotDeals.filter { product in
            searchText.isEmpty ||
            product.name.localizedCaseInsensitiveContains(searchText) ||
            product.brand.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Components
    
    private var customSearchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("მოძებნე ნაწილები...", text: $searchText)
                .autocorrectionDisabled()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var searchResultsGrid: some View {
        VStack(alignment: .leading) {
            if filteredProducts.isEmpty {
                emptyStateView
            } else {
                Text("ძებნის შედეგები: \(filteredProducts.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredProducts) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }
    
    private var mainHomeContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            if !viewModel.offers.isEmpty {
                offersSection
            }
            
            categoriesSection
            
            hotDealsSection
        }
        .padding(.top)
    }
    
    private var offersSection: some View {
        VStack(alignment: .leading) {
            Text("სპეციალური შეთავაზებები")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.offers) { offer in
                        OfferCard(offer: offer)
                            .frame(width: 300)
                            .onTapGesture {
                                selectedOffer = offer // Sheet-ის გამოძახება
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("კატეგორიები")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.categories) { category in
                        NavigationLink(destination: CategoryProductsView(category: category)) {
                            CategoryItemView(category: category)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var hotDealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("ცხელი შეთავაზებები")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if viewModel.hotDeals.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.hotDeals) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "cart.badge.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("პროდუქტები ვერ მოიძებნა")
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }
}

// MARK: - Offer Detail Sheet
struct OfferDetailSheet: View {
    let offer: Offer
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 200)
                        
                        Image(systemName: "gift.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(offer.title)
                            .font(.title)
                            .bold()
                        
                        Text(offer.subtitle)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        Text("აქციის პირობები:")
                            .font(.headline)
                        
                        Text("მოცემული შეთავაზება მოქმედებს AutoMate-ის ყველა პარტნიორ ფილიალში. ფასდაკლების მისაღებად წარადგინეთ აპლიკაციაში არსებული QR კოდი ან დაუკავშირდით ცხელ ხაზს.")
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("დახურვა") { dismiss() }
                }
            }
        }
        .presentationDetents([.large])
    }
}
