//
//  GuestPlaceholderView.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import SwiftUI

struct GuestPlaceholderView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 25) {
            // ილუსტრაცია/ხატულა
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.badge.shield.exclamation.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            
            VStack(spacing: 15) {
                // რეგისტრაციის ღილაკი
                NavigationLink(destination: RegistrationView()) {
                    Text("რეგისტრაცია")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                // ლოგინის გვერდზე დაბრუნება (Anonymous სესიის დასასრულებლად)
                Button {
                    AuthManager.shared.signOut()
                } label: {
                    Text("ავტორიზაცია")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)
        }
        .padding()
    }
}

//#Preview {
//    NavigationStack {
//        GuestPlaceholderView(title: "წვდომა შეზღუდულია", message: "სერვისების მისაღებად საჭიროა რეგისტრაცია")
//    }
//}
