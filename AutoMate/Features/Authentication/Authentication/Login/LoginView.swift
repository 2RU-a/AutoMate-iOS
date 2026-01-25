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
    @StateObject private var lang = LocalizationManager.shared
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
                    
                    Text(lang.t("your_auto_assistant")) // "თქვენი ავტო-ასისტენტი"
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Email/Password ველები
                VStack(spacing: 15) {
                    TextField(lang.t("email"), text: $email) // "ელ-ფოსტა"
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    
                    SecureField(lang.t("password"), text: $password) // "პაროლი"
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
                    HStack {
                        if authManager.isLoading {
                            UIKitLoadingIndicator(isAnimating: true, style: .medium)
                                .padding(.trailing, 5)
                        }
                        
                        Text(authManager.isLoading ? lang.t("loading") : lang.t("login_btn"))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(email.isEmpty || password.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
                }
                .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                
                // "ან" გამყოფი
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text(lang.t("or")).font(.caption).foregroundColor(.gray) // "ან"
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    // Google Login Button - დაკავშირებული ლოგიკასთან
                    Button(action: {
                        authManager.signInWithGoogle { success, error in
                            if success {
                                print("Google Login Success")
                            } else {
                                print("Google Login Error: \(error ?? "")")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                            Text(lang.t("sign_in_google")) // "Google-ით შესვლა"
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
                    
                    NavigationLink(destination: PhoneLoginView()) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(lang.t("sign_in_phone")) // "ტელეფონის ნომრით შესვლა"
                        }
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
                        Label(lang.t("sign_in_anonymous"), systemImage: "person.badge.shield.exclamation.fill") // "ანონიმურად შესვლა"
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(12)
                    }

                    NavigationLink(destination: RegistrationView()) {
                        Label(lang.t("registration"), systemImage: "person.badge.plus") // "რეგისტრაცია"
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
}
