//
//  ProfileView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var addressManager = AddressManager.shared
    @StateObject private var lang = LocalizationManager.shared // ენის მენეჯერი
    
    @State private var showEmailEdit = false
    @State private var showPrivacyPolicy = false
    @State private var showLogoutAlert = false
    @AppStorage("selected_language") private var selectedLanguage = "ka"
    
    var body: some View {
        NavigationStack {
            List {
                // 1. პროფილის ინფორმაცია
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authManager.userName.isEmpty ? lang.t("user") : authManager.userName)
                                .font(.headline)
                            
                            HStack {
                                Text(authManager.userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button {
                                    showEmailEdit = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 18))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                // 2. მისამართის სექცია
                Section(lang.t("delivery")) {
                    NavigationLink(destination: AddressManagementView()) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lang.t("address"))
                                .font(.body)
                            Text(addressManager.addresses.first(where: { $0.isDefault })?.fullAddress ?? lang.t("no_address"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // 3. ავტოფარეხი
                Section(lang.t("my_cars")) {
                    NavigationLink(destination: VehicleManagementView()) {
                        HStack {
                            Image(systemName: "car.2.fill")
                            Text(lang.t("garage"))
                        }
                    }
                }

                // 4. ვაჭრობა და აქტივობა
                Section(lang.t("activity")) {
                    NavigationLink(destination: OrdersHistoryView()) {
                        Label(lang.t("orders"), systemImage: "bag.fill")
                    }
                    
                    NavigationLink(destination: ServiceHistoryView()) {
                        Label(lang.t("service_history"), systemImage: "wrench.and.screwdriver.fill")
                    }
                }

                // 5. პარამეტრები და დახმარება
                Section(lang.t("settings")) {
                    NavigationLink(destination: LanguageView()) {
                        HStack {
                            Label(lang.t("language"), systemImage: "globe")
                            Spacer()
                            Text(selectedLanguage == "ka" ? "🇬🇪" : "🇬🇧")
                        }
                    }
                    
                    NavigationLink(destination: FAQView()) {
                        Label(lang.t("faq"), systemImage: "questionmark.circle")
                    }
                    
                    Button(action: { showPrivacyPolicy = true }) {
                        Label(lang.t("privacy_policy"), systemImage: "lock.shield")
                    }
                    .foregroundColor(.primary)
                }

                // 6. გასვლა / შესვლა
                Section {
                    Button(role: authManager.isAnonymous ? .none : .destructive, action: {
                        if authManager.isAnonymous {
                            authManager.signOut()
                        } else {
                            showLogoutAlert = true
                        }
                    }) {
                        Label(
                            authManager.isAnonymous ? lang.t("login") : lang.t("logout"),
                            systemImage: authManager.isAnonymous ? "arrow.left.circle" : "arrow.right.circle"
                        )
                    }
                }
                .alert(lang.t("logout_confirm"), isPresented: $showLogoutAlert) {
                    Button(lang.t("logout"), role: .destructive) {
                        authManager.signOut()
                    }
                    Button(lang.t("cancel"), role: .cancel) { }
                } message: {
                    Text("")
                }
            }
            .navigationTitle(lang.t("profile"))
            .sheet(isPresented: $showEmailEdit) {
                EmailUpdateView(currentEmail: authManager.userEmail)
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://www.apple.com/legal/privacy/")!)
            }
        }
    }
}

// MARK: - Email Update View
struct EmailUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var lang = LocalizationManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var errorMsg = ""
    @State private var showSuccessAlert = false
    
    let currentEmail: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("\(lang.t("current")): \(currentEmail)")) {
                    TextField(lang.t("new_email"), text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text(lang.t("confirmation")), footer: Text(lang.t("password_required_hint"))) {
                    SecureField(lang.t("enter_password"), text: $password)
                }
                
                if !errorMsg.isEmpty {
                    Text(errorMsg).foregroundColor(.red).font(.caption)
                }
                
                Button(lang.t("request_update")) {
                    updateEmailAction()
                }
                .frame(maxWidth: .infinity)
                .disabled(email.isEmpty || password.isEmpty)
            }
            .navigationTitle(lang.t("change_email"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(lang.t("close")) { dismiss() }
                }
            }
            .alert(lang.t("link_sent"), isPresented: $showSuccessAlert) {
                Button(lang.t("ok")) { dismiss() }
            } message: {
                Text(lang.t("email_verification_msg") + " \(email).")
            }
        }
    }
    
    private func updateEmailAction() {
        authManager.updateUserEmail(newEmail: email, password: password) { success, error in
            if success {
                showSuccessAlert = true
            } else {
                errorMsg = error ?? lang.t("update_error")
            }
        }
    }
}
