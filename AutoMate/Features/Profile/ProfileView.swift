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
    
    @State private var showEmailEdit = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authManager.userName.isEmpty ? "მომხმარებელი" : authManager.userName)
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
                        }                    }
                    .padding(.vertical, 8)
                }

                // 2. მისამართის სექცია
                Section("მიწოდება") {
                    NavigationLink(destination: AddressManagementView()) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("მისამართების მართვა")
                                .font(.body)
                            Text(addressManager.addresses.first(where: { $0.isDefault })?.fullAddress ?? "მისამართი არ არის მითითებული")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // 3. ავტოფარეხი
                Section("ჩემი ავტომობილები") {
                    NavigationLink(destination: VehicleManagementView()) {
                        HStack {
                            Image(systemName: "car.2.fill")
                            Text("ავტოფარეხი")
                        }
                    }
                }

                // 4. ვაჭრობა და აქტივობა
                Section("აქტივობა") {
                    NavigationLink(destination: OrdersHistoryView()) {
                        Label("შეკვეთების ისტორია", systemImage: "bag.fill")
                    }
                    
                    // ნოტიფიკაციების ნაცვლად ჩავსვათ სერვისების ისტორია
                    NavigationLink(destination: ServiceHistoryView()) {
                        Label("სერვისების ისტორია", systemImage: "wrench.and.screwdriver.fill")
                    }
                }

                // 5. პარამეტრები და დახმარება
                Section("პარამეტრები") {
                    NavigationLink(destination: Text("Language View")) {
                        Label("ენა", systemImage: "globe")
                    }
                    
                    NavigationLink(destination: Text("FAQ View")) {
                        Label("ხშირად დასმული კითხვები", systemImage: "questionmark.circle")
                    }
                    
                    Button(action: { showPrivacyPolicy = true }) {
                        Label("კონფიდენციალურობის პოლიტიკა", systemImage: "lock.shield")
                    }
                    .foregroundColor(.primary)
                }

                // 6. გასვლა
                Section {
                    Button(role: .destructive, action: { authManager.signOut() }) {
                        Label("გასვლა", systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("პროფილი")
            .sheet(isPresented: $showEmailEdit) {
                EmailUpdateView(currentEmail: authManager.userEmail)
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://www.apple.com/legal/privacy/")!) // ჩასვი შენი ლინკი
            }
        }
    }
}


// MARK: - Email Update View (განახლებული ლოგიკით)
struct EmailUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var errorMsg = ""
    @State private var showSuccessAlert = false
    
    let currentEmail: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("მიმდინარე: \(currentEmail)")) {
                    TextField("ახალი ელ-ფოსტა", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("დადასტურება"), footer: Text("უსაფრთხოებისთვის საჭიროა პაროლის შეყვანა.")) {
                    SecureField("შეიყვანეთ პაროლი", text: $password)
                }
                
                if !errorMsg.isEmpty {
                    Text(errorMsg).foregroundColor(.red).font(.caption)
                }
                
                Button("განახლების მოთხოვნა") {
                    updateEmailAction()
                }
                .frame(maxWidth: .infinity)
                .disabled(email.isEmpty || password.isEmpty)
            }
            .navigationTitle("იმეილის შეცვლა")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("დახურვა") { dismiss() }
                }
            }
            .alert("ბმული გაიგზავნა", isPresented: $showSuccessAlert) {
                Button("გავიგე") { dismiss() }
            } message: {
                Text("იმეილის შესაცვლელად დააჭირეთ დასტურის ბმულს, რომელიც გაიგზავნა \(email)-ზე.")
            }
        }
    }
    
    private func updateEmailAction() {
        authManager.updateUserEmail(newEmail: email, password: password) { success, error in
            if success {
                showSuccessAlert = true
            } else {
                errorMsg = error ?? "შეცდომა განახლებისას"
            }
        }
    }
}
