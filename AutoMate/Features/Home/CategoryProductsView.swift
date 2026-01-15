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
    @State private var searchText = ""
    
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
            // 🏷 ფილტრების ჰორიზონტალური ზოლი
            filterSection
            
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if filteredProducts.isEmpty {
                        emptyStateView
                    } else {
                        // 🛒 პროდუქტების გრიდი
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredProducts) { product in
                                // გადასვლა დეტალურ გვერდზე
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
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .searchable(text: $searchText, prompt: "მოძებნე \(category.name)...")
        .task {
            await viewModel.loadProducts()
        }
    }
    
    // MARK: - Components
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterChip(title: "ბრენდი", icon: "chevron.down")
                
                // დინამიური ფილტრები კატეგორიის მიხედვით
                if category.id == "5" { // ზეთები
                    FilterChip(title: "სიბლანტე", icon: "drop.fill")
                    FilterChip(title: "მოცულობა", icon: "litres.sign")
                } else if category.id == "4" { // საბურავები
                    FilterChip(title: "სეზონი", icon: "sun.max.fill")
                    FilterChip(title: "ზომა", icon: "ruler.fill")
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
            Text(searchText.isEmpty ? "ამ კატეგორიაში პროდუქტები ჯერ არ არის" : "პროდუქტი ვერ მოიძებნა")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
    
    // MARK: - Logic
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// MARK: - Filter Chip Component
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
