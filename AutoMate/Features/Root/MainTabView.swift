//
//  MainTabView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    // 1. დავაკავშიროთ CartManager-თან, რომ ბეიჯი დინამიური იყოს
    @StateObject private var cartManager = CartManager.shared
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("მთავარი", systemImage: "house")
            }
            .tag(Tab.home)
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("ფავორიტი", systemImage: "heart.fill")
            }
            .tag(Tab.favorites)
            
            NavigationStack {
                MyCarView()
            }
            .tabItem {
                Label("ჩემი მანქანა", systemImage: "car.fill")
            }
            .tag(Tab.mycar)
            
            NavigationStack {
                CartView()
            }

            .badge(cartManager.items.count > 0 ? cartManager.items.count : 0)
            .tabItem {
                Label("კალათა", systemImage: "cart")
            }
            .tag(Tab.cart)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("პროფილი", systemImage: "person.circle")
            }
            .tag(Tab.profile)
        }
        .tint(Color.blue)
    }
}

enum Tab: String, CaseIterable {
    case home, favorites, mycar, cart, profile
}
