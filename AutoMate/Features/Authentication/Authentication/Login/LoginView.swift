//
//  LoginView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // ზედა ვიზუალური ნაწილი
                VStack(spacing: 8) {
                    Image(systemName: "car.side.rear.open.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    Text("AutoMate")
                        .font(.largeTitle)
                        .fontWeight(.black)
                    
                    Text("თქვენი ავტო-ასისტენტი")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Email/Password ველები
                VStack(spacing: 15) {
                    TextField("ელ-ფოსტა", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    
                    SecureField("პაროლი", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                if let error = authManager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                // მთავარი ლოგინის ღილაკი
                Button {
                    authManager.login(withEmail: email, password: password)
                } label: {
                    Text("შესვლა")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // "ან" გამყოფი
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("ან").font(.caption).foregroundColor(.gray)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    socialLoginButton(icon: "google_logo", title: "Google-ით შესვლა", color: .clear)
                    
                    Button(action: { /* Phone Auth Logic */ }) {
                        Label("ტელეფონის ნომრით შესვლა", systemImage: "phone.fill")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        authManager.signInAnonymously()
                    }) {
                        Label("ანონიმურად შესვლა", systemImage: "person.badge.shield.exclamation.fill")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(12)
                    }

                    NavigationLink(destination: RegistrationView()) {
                        Label("რეგისტრაცია", systemImage: "person.badge.plus")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // დამხმარე კომპონენტი სოციალური ღილაკებისთვის
    private func socialLoginButton(icon: String, title: String, color: Color) -> some View {
        Button(action: { /* Google login logic */ }) {
            HStack {
                Image(systemName: "g.circle.fill") // დროებითი ხატულა
                Text(title)
            }
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    LoginView()
}
