//
//  RegisterView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI
import Foundation

struct RegistrationView: View {
    @StateObject private var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showPasswordError = false
    @State private var validationTask: Task<Void, Never>? = nil // დაყოვნების პროცესის სამართავად
    
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("შექმენი ანგარიში")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            
            // Input Fields
            VStack(spacing: 15) {
                customTextField(title: "სახელი", text: $name, icon: "person")
                customTextField(title: "გვარი", text: $surname, icon: "person")
                customTextField(title: "ელ-ფოსტა", text: $email, icon: "envelope")
                    .keyboardType(.emailAddress)
                
                customSecureField(title: "პაროლი", text: $password)
                customSecureField(title: "გაიმეორეთ პაროლი", text: $confirmPassword)
                    .onChange(of: confirmPassword) { oldValue, newValue in
                            validatePasswords()
                        }
                        .onChange(of: password) { oldValue, newValue in
                            validatePasswords()
                        }
            }
            .padding(.top, 20)
            
            // Validation Note
            if showPasswordError {
                Text("პაროლი არ ემთხვევა")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // Register Button
            if let error = authManager.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                let fullName = "\(name) \(surname)"
                authManager.register(withEmail: email, password: password, fullName: fullName)
            } label: {
                Text("რეგისტრაცია")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isFormValid)
            .padding(.top, 10)
            
            Spacer()
            
            // Back to Login
            Button {
                dismiss()
            } label: {
                VStack(spacing: 4) {
                    Text("თუ უკვე გაქვთ ანგარიში")
                    Text("შესვლა").fontWeight(.bold)
                }
                .font(.headline)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(false) // "უკან" ღილაკი გვაქვს ბოლოში
    }
    
    // MARK: - Helpers & Validation
    
    private var isFormValid: Bool {
            !email.isEmpty && email.contains("@") &&
            !password.isEmpty && password.count >= 6 &&
            password == confirmPassword &&
            !name.isEmpty && !surname.isEmpty
        }
    private func validatePasswords() {
        // ყოველ ახალ ასოზე ვაუქმებთ წინა დაგეგმილ შემოწმებას
        validationTask?.cancel()
        
        // თუ ველები ცარიელია, მაშინვე ვაქრობთ ერორს
        if password.isEmpty || confirmPassword.isEmpty {
            showPasswordError = false
            return
        }
        
        // ვგეგმავთ ახალ შემოწმებას 0.8 წამის შემდეგ
        validationTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8 წამი
            
            // თუ ტასკი არ გაუქმდა (ანუ მომხმარებელმა ბეჭდვა შეწყვიტა)
            if !Task.isCancelled {
                await MainActor.run {
                    showPasswordError = (password != confirmPassword)
                }
            }
        }
    }
    
    private func customTextField(title: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            TextField(title, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func customSecureField(title: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: "lock").foregroundColor(.gray)
            SecureField(title, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
