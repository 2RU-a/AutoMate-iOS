//
//  HomeView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI  

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    // ძებნის და ფილტრაციის State-ები
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var filterOptions = FilterOptions()
    
    // Grid-ის კონფიგურაცია
//    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. ტოპ ჰედერი
            HomeHeaderView()
            
            // 2. საძიებო ზოლი
            searchAndFilterBar
                .padding(.vertical, 10)
            
            // 3. კონტენტი
            ScrollView {
                if !searchText.isEmpty {
                    searchResultsGrid
                } else {
                    mainHomeContent
                }
            }
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showFilters) {
            FilterView(
                options: $filterOptions,
                categoryName: "პროდუქტები",
                categoryId: "all"
            )
        }
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.loadData()
            }
        }
    }
    
    // MARK: - Computed Property (ფილტრაციის ლოგიკა)
    private var filteredProducts: [Product] {
        viewModel.products.filter { product in
            let matchesSearch = searchText.isEmpty ||
                               product.name.localizedCaseInsensitiveContains(searchText) ||
                               product.brand.localizedCaseInsensitiveContains(searchText)
            
            let matchesBrand = filterOptions.selectedBrands.isEmpty ||
                              filterOptions.selectedBrands.contains(product.brand)
            
            let matchesMinPrice = filterOptions.minPrice == nil || product.price >= (filterOptions.minPrice ?? 0)
            let matchesMaxPrice = filterOptions.maxPrice == nil || product.price <= (filterOptions.maxPrice ?? Double.infinity)
            
            return matchesSearch && matchesBrand && matchesMinPrice && matchesMaxPrice
        }
        .sorted { p1, p2 in
            switch filterOptions.sortBy {
            case .priceLowHigh: return p1.price < p2.price
            case .priceHighLow: return p1.price > p2.price
            case .newest: return (p1.id ?? "") > (p2.id ?? "")
            }
        }
    }
    
    // MARK: - საძიებო ზოლი
    private var searchAndFilterBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("მოძებნე ნაწილები...", text: $searchText)
                    .autocorrectionDisabled()
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            
            Button {
                showFilters.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .symbolVariant(!filterOptions.selectedBrands.isEmpty || filterOptions.minPrice != nil ? .fill : .none)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - ძებნის შედეგები
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
    
    // MARK: - მთავარი კონტენტი
    private var mainHomeContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            if !viewModel.offers.isEmpty {
                offersSection
            }
            
            categoriesSection
            
            // Firebase პროდუქტების სექცია
            allProductsSection
        }
        .padding(.top)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "cart.badge.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("პროდუქტები ვერ მოიძებნა")
                .font(.headline)
            
            Text("ახალი პროდუქტები მალე დაემატება, გთხოვთ შემოგვიაროთ მოგვიანებით.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }
    
    // MARK: - Sections
    private var allProductsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("ყველა პროდუქტი")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity)
            } else if viewModel.products.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.products) { product in
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
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
