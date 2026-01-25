//
//  RootView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation
import SwiftUI

struct RootView: View {
    // ვაკავშირებთ AuthManager-ს, რომელიც აკონტროლებს სესიას
    @StateObject var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            // ვამოწმებთ, არის თუ არა userSession შევსებული
            if authManager.userSession != nil {
                MainTabView()
            } else {
                // თუ არ არის დალოგინებული, ვაჩვენებთ ლოგინის გვერდს
                LoginView()
            }
        }
        // როდესაც სესია იცვლება (მომხმარებელი შედის ან გამოდის),
        // ვაიძულებთ VehicleManager-ს თავიდან წამოიღოს მონაცემები
        .onChange(of: authManager.userSession) { oldValue, newValue in
            if newValue != nil {
                // თუ მომხმარებელი დალოგინდა, წამოვიღოთ მისი მანქანები
                VehicleManager.shared.fetchCars()
            } else {
                // თუ გამოვიდა, სია გავასუფთავოთ (უსაფრთხოებისთვის)
                VehicleManager.shared.cars = []
            }
        }
    }
}

//#Preview {
//    RootView()
//}
