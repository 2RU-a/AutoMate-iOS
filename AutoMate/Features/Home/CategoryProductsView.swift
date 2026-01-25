//
//  CategoryProductsView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct CategoryProductsView: View {
    let category: Category
    @StateObject private var viewModel: CategoryProductsViewModel
    
    // MARK: - State Properties
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var filterOptions = FilterOptions()
    
    // ინიციალიზატორი
    init(category: Category) {
        self.category = category
        _viewModel = StateObject(wrappedValue: CategoryProductsViewModel(categoryId: category.id))
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. მუდმივი საძიებო ველი
            customSearchBar
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
            
            // 2. ფილტრების ჰორიზონტალური ზოლი
            filterSection
            
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if filteredProducts.isEmpty {
                        emptyStateView
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
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
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilters.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .symbolVariant(!filterOptions.selectedBrands.isEmpty ? .fill : .none)
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView(options: $filterOptions,
                       categoryName: category.displayName,
                       categoryId: category.id)
        }
        .task {
            await viewModel.loadProducts()
        }
    }
    
    // MARK: - Components
    
    private var customSearchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("მოძებნე \(category.displayName)...", text: $searchText)
                .autocorrectionDisabled()
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Menu {
                    ForEach(viewModel.availableBrands, id: \.self) { brand in
                        Button {
                            toggleBrand(brand)
                        } label: {
                            HStack {
                                Text(brand)
                                if filterOptions.selectedBrands.contains(brand) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    FilterChip(
                        title: filterOptions.selectedBrands.isEmpty ? "ბრენდი" : "ბრენდი (\(filterOptions.selectedBrands.count))",
                        icon: "chevron.down"
                    )
                }
                
                if category.id == "5" { // ზეთები
                    FilterChip(title: filterOptions.viscosity ?? "სიბლანტე", icon: "drop.fill")
                } else if category.id == "4" { // საბურავები
                    FilterChip(title: "სეზონი", icon: "sun.max.fill")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color(.systemBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text(searchText.isEmpty ? "პროდუქტები ჯერ არ არის" : "ვერ მოიძებნა")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
    
    // MARK: - Logic
    
    private func toggleBrand(_ brand: String) {
        if filterOptions.selectedBrands.contains(brand) {
            filterOptions.selectedBrands.remove(brand)
        } else {
            filterOptions.selectedBrands.insert(brand)
        }
    }
    
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
            case .newest:
                // ვიყენებთ Nil Coalescing ("") Optional-ის ამოსაღებად
                return (p1.id ?? "") > (p2.id ?? "")
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
            Image(systemName: icon)
                .font(.system(size: 10))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .font(.caption)
        .fontWeight(.medium)
    }
}
