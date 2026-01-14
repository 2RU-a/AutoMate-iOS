//
//  RootView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import Foundation
import SwiftUI

struct RootView: View {
    // აქ მომავალში დაემატება @EnvironmentObject var authService...
    @State private var isAuthenticated: Bool = true // დროებით: სულ დალოგინებულია
    
    var body: some View {
        Group {
            if isAuthenticated {
                MainTabView()
            } else {
                // მომავალში აქ იქნება:
                // LoginView()
                Text("Login Screen")
            }
        }
    }
}

#Preview {
    RootView()
}
