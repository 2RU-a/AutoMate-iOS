//
//  ProfileView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared // დავამატეთ სესიის კონტროლისთვის
    
    var body: some View {
        NavigationStack {
            List {
                if authManager.isAnonymous {
                    // (თუ ანონიმურია)
                    Section {
                        GuestPlaceholderView(
                            title: "პროფილი",
                            message: "თქვენი მონაცემების სანახავად და სამართავად გთხოვთ გაიაროთ რეგისტრაცია"
                        )
                        .listRowBackground(Color.clear) // რომ სექციის ჩარჩო არ გამოჩნდეს
                    }
                } else {
                    // ავტორიზებული მომხმარებლის ხედი
                    
                    // პირადი ინფორმაცია (რეალური მონაცემებით)
                    Section(header: Text("პირადი ინფორმაცია")) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 15) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    // Firebase-დან წამოღებული სახელი (თუ გვაქვს)
                                    Text(authManager.userSession?.displayName ?? "მომხმარებელი")
                                        .font(.headline)
                                    // Firebase-დან წამოღებული მეილი
                                    Text(authManager.userSession?.email ?? "იმეილი არ არის")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Divider()
                            
                            Group {
                                ProfileInfoRow(label: "იმეილი", value: authManager.userSession?.email ?? "-")
                                
                                NavigationLink(destination: AddressManagementView()) {
                                    ProfileInfoRow(label: "მისამართი", value: "თბილისი, ჭავჭავაძის გამზ. 1")
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    // ჩემი აქტივობა
                    Section(header: Text("ჩემი აქტივობა")) {
                        NavigationLink(destination: OrdersHistoryView()) {
                            ProfileMenuRow(icon: "bag.fill", title: "შეკვეთები", color: .orange)
                        }
                        
                        NavigationLink(destination: VehicleManagementView()) {
                            ProfileMenuRow(icon: "car.fill", title: "მანქანების მართვა", color: .blue)
                        }
                        
                        NavigationLink(destination: FavoritesView()) {
                            ProfileMenuRow(icon: "heart.fill", title: "სასურველი ნივთები", color: .red)
                        }
                    }
                    
                    // აპლიკაციის პარამეტრები
                    Section(header: Text("აპლიკაციის პარამეტრები")) {
                        Toggle(isOn: .constant(true)) {
                            HStack {
                                Image(systemName: "bell.fill").foregroundColor(.orange)
                                Text("ნოტიფიკაციები")
                            }
                        }
                        
                        NavigationLink(destination: Text("ენის არჩევა")) {
                            ProfileMenuRow(icon: "globe", title: "ენა", color: .green)
                        }
                    }
                    
                    // მხარდაჭერა
                    Section(header: Text("მხარდაჭერა")) {
                        NavigationLink(destination: FAQView()) {
                            ProfileMenuRow(icon: "questionmark.circle.fill", title: "ხშირად დასმული კითხვები (FAQ)", color: .purple)
                        }
                    }
                    
                    // Logout ღილაკი
                    Section {
                        Button(role: .destructive) {
                            authManager.signOut()
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("გამოსვლა")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("პროფილი")
        }
    }
}

// MARK: - Profile Menu Row Component (შენარჩუნებულია უცვლელად)
struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .cornerRadius(6)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Profile Info Row (შენარჩუნებულია უცვლელად)
struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
            Text(value)
                .font(.footnote)
                .lineLimit(1)
        }
    }
}
