//
//  HomeHeaderView.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct HomeHeaderView: View {
    // მომავალში აქ User-ის სახელი შემოვა
    var userName: String = "მძღოლო"
    
    var body: some View {
        HStack {
            // ტექსტები
            VStack(alignment: .leading, spacing: 4) {
                Text("გამარჯობა, \(userName) 👋")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("რას ეძებ დღეს?")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // ნოტიფიკაციის ღილაკი
            Button {
                // Action
            } label: {
                Image(systemName: "bell.badge") // წერტილიანი ზარი
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color(.systemBackground)) // ფონი აუცილებელია, რომ სქროლისას არ გამჭვირვალედეს
    }
}

#Preview {
    HomeHeaderView()
}
