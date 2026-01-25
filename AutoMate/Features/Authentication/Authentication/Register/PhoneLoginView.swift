//
//  PhoneLoginView.swift
//  AutoMate
//
//  Created by oto rurua on 25.01.26.
//

import SwiftUI

struct PhoneLoginView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var lang = LocalizationManager.shared
    @State private var phoneNumber = "+995"
    @State private var verificationCode = ""
    @State private var isCodeSent = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 25) {
            VStack(alignment: .leading, spacing: 10) {
                Text(isCodeSent ? lang.t("enter_sms_code") : lang.t("enter_phone_number"))
                    .font(.title2)
                    .bold()
                
                Text(isCodeSent ? lang.t("sms_sent_to") + " \(phoneNumber)" : lang.t("phone_hint"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)

            if !isCodeSent {
                TextField("+995 5xx xxx xxx", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            } else {
                TextField("123456", text: $verificationCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }

            if let error = authManager.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }

            Button {
                if isCodeSent {
                    authManager.verifyCode(verificationCode) { success, error in
                        if success { dismiss() }
                    }
                } else {
                    authManager.sendVerificationCode(phoneNumber: phoneNumber) { success, error in
                        if success { isCodeSent = true }
                    }
                }
            } label: {
                HStack {
                    if authManager.isLoading {
                        ProgressView().tint(.white).padding(.trailing, 5)
                    }
                    Text(isCodeSent ? lang.t("verify") : lang.t("send_code"))
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(phoneNumber.count < 9 ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(authManager.isLoading || phoneNumber.count < 9)
            
            Spacer()
        }
        .padding()
        .navigationTitle(lang.t("sign_in_phone"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
