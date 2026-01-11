//
//  AutoMateApp.swift
//  AutoMate
//
//  Created by oto rurua on 09.01.26.
//

import SwiftUI
import Firebase


@main
struct AutoMateApp: App {
    init() {
            FirebaseApp.configure()
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
