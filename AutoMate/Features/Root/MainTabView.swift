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
    @StateObject private var lang = LocalizationManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(lang.t("Home"), systemImage: "house")
            }
            .tag(Tab.home)
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label(lang.t("Saved"), systemImage: "heart.fill")

            }
            .tag(Tab.favorites)
            
            NavigationStack {
                MyCarView()
            }
            .tabItem {
                Label(lang.t("My car"), systemImage: "car.fill")
            }
            .tag(Tab.mycar)
            
            NavigationStack {
                CartView()
            }

            .badge(cartManager.items.count > 0 ? cartManager.items.count : 0)
            .tabItem {
                Label(lang.t("Cart"), systemImage: "cart")
            }
            .tag(Tab.cart)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(lang.t("Profile"), systemImage: "person.circle")

            }
            .tag(Tab.profile)
        }
        .tint(Color.blue)
        .id(lang.selectedLanguage)
    }
}

enum Tab: String, CaseIterable {
    case home, favorites, mycar, cart, profile
}
