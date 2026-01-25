//
//  HomeHeaderView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI
import FirebaseAuth

struct HomeHeaderView: View {
    // ვაკავშირებთ AuthManager-ს სესიის მონაცემების მისაღებად
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("გამარჯობა \(authManager.userSession?.displayName ?? "") 👋")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // ნოტიფიკაციის ღილაკი
//            Button {
//                // Action
//            } label: {
//                Image(systemName: "bell.badge")
//                    .font(.title3)
//                    .foregroundColor(.primary)
//                    .padding(10)
//                    .background(Color(.secondarySystemBackground))
//                    .clipShape(Circle())
//            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color(.systemBackground))
    }
}

