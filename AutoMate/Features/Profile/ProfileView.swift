//
//  ProfileView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            // 1. Personal Info სექცია
            Section(header: Text("პირადი ინფორმაცია")) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("ოთო რურუა")
                                .font(.headline)
                            Text("+995 555 12 34 56")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    Group {
                        ProfileInfoRow(label: "იმეილი", value: "oto.rurua@example.com")
                        
                        // მისამართის მართვაზე გადასვლა
                        NavigationLink(destination: AddressManagementView()) {
                            ProfileInfoRow(label: "მისამართი", value: "თბილისი, ჭავჭავაძის გამზ. 1")
                        }
                    }
                }
                .padding(.vertical, 5)
            }
            
            // 2. ჩემი აქტივობა
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
            // 3. App Settings
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
            
            // 4. დახმარება და FAQ
            Section(header: Text("მხარდაჭერა")) {
                NavigationLink(destination: FAQView()) {
                    ProfileMenuRow(icon: "questionmark.circle.fill", title: "ხშირად დასმული კითხვები (FAQ)", color: .purple)
                }
            }
            
            // 5. Logout
            Section {
                Button(role: .destructive) {
                    // Logout Action
                } label: {
                    HStack {
                        Spacer()
                        Text("გასვლა")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("პროფილი")
    }
}

// MARK: - Profile Menu Row Component
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

// დამხმარე კომპონენტი პირადი ინფოსთვის
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
