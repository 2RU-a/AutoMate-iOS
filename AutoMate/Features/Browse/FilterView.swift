//
//  FilterView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var options: FilterOptions
    
    let categoryName: String
    let categoryId: String
    
    // ბრენდების სია (შეგიძლია დაამატო შენი სურვილისამებრ)
    let availableBrands = ["Castrol", "Mobil1", "Shell", "Motul", "BMW Genuine", "Varta", "Brembo"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. ფილტრების ფორმა
                Form {
                    Section(header: Text("ბრენდები")) {
                        ForEach(availableBrands, id: \.self) { brand in
                            Button {
                                toggleBrand(brand)
                            } label: {
                                HStack {
                                    Text(brand)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if options.selectedBrands.contains(brand) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    
                    // 2. დინამიური სექცია კატეგორიის მიხედვით
                    dynamicCategorySection
                    
                    // 3. ფასის სექცია
                    Section(header: Text("ფასი (₾)")) {
                        HStack {
                            TextField("დან", value: $options.minPrice, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("მდე", value: $options.maxPrice, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // 4. სორტირება
                    Section(header: Text("სორტირება")) {
                        Picker("დალაგება", selection: $options.sortBy) {
                            ForEach(FilterOptions.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
                
                // 5. ფიქსირებული ღილაკები ბოლოში
                footerActionButtons
            }
            .navigationTitle("\(categoryName)-ს ფილტრი")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Dynamic Section
    @ViewBuilder
    private var dynamicCategorySection: some View {
        if categoryId == "5" { // ზეთები
            Section(header: Text("ზეთის მახასიათებლები")) {
                Picker("სიბლანტე", selection: $options.viscosity) {
                    Text("ყველა").tag(String?.none)
                    Text("5W-30").tag("5W-30")
                    Text("10W-40").tag("10W-40")
                    Text("0W-20").tag("0W-20")
                }
            }
        } else if categoryId == "4" { // საბურავები
            Section(header: Text("საბურავის მახასიათებლები")) {
                Picker("სეზონი", selection: $options.tireSeason) {
                    Text("ყველა").tag(String?.none)
                    Text("ზაფხული").tag("Summer")
                    Text("ზამთარი").tag("Winter")
                    Text("ყველა სეზონი").tag("All Season")
                }
            }
        }
    }
    
    // MARK: - Footer Buttons
    private var footerActionButtons: some View {
        VStack {
            Divider()
            HStack(spacing: 15) {
                // გასუფთავების ღილაკი
                Button(action: resetFilters) {
                    Text("გასუფთავება")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
                
                // გამოყენების ღილაკი
                Button(action: { dismiss() }) {
                    Text("გამოყენება")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding([.horizontal, .bottom])
            .padding(.top, 10)
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Functions
    private func toggleBrand(_ brand: String) {
        if options.selectedBrands.contains(brand) {
            options.selectedBrands.remove(brand)
        } else {
            options.selectedBrands.insert(brand)
        }
    }
    
    private func resetFilters() {
        withAnimation {
            options = FilterOptions() // აბრუნებს საწყის მნიშვნელობებზე
        }
    }
}
