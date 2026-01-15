//
//  MainTabView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    // არჩეული ტაბის შესანახად
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Home Tab
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("მთავარი", systemImage: "house")
            }
            .tag(Tab.home)
            
            //Favorites Tab
            NavigationStack {
                FavoritesView() // ან BrowseView
            }
            .tabItem {
                Label("ფავორიტი", systemImage: "heart.fill")
            }
            .tag(Tab.browse)
            
            // My Car Tab
            NavigationStack {
                MyCarView()
            }
            .tabItem {
                Label("ჩემი მანქანა", systemImage: "car.fill")
            }
            .tag(Tab.mycar)
            
            //Cart Tab
            NavigationStack {
                CartView()
            }
            .badge(1) // მაგალითისთვის: კალათში 1 ნივთია
            .tabItem {
                Label("კალათა", systemImage: "cart")
            }
            .tag(Tab.cart)
            
            // Profile Tab
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("პროფილი", systemImage: "person.circle")
            }
            .tag(Tab.profile)
        }
        // ტაბების ფერის კონფიგურაცია (Theme-დან)
        .tint(Color.blue) // აქ გამოიყენე შენი DesignSystem.Colors.primary
    }
}

// ტაბების ენამი (Type-safe selection-ისთვის)
enum Tab: String, CaseIterable {
    case home, browse, mycar, cart, profile
}

#Preview {
    MainTabView()
}
