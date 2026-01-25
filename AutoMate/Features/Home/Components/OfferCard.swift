//
//  OfferCard.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI

struct OfferCard: View {
    let offer: Offer
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(offer.subtitle.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(offer.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Button("დეტალურად") {
                    // Action
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(20)
                .padding(.top, 4)
            }
            
            Spacer()
            
            // დეკორატიული რამე icon
            Image(systemName: "percent")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.2))
                .rotationEffect(.degrees(-20))
        }
        .padding(20)
        .frame(height: 160)
        .background(
            LinearGradient(
                colors: [Color.red, Color.yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

//#Preview {
//    OfferCard(offer: Offer(id: "1", title: "საბურავები", subtitle: "ზამთრის აქცია", colorCode: "blue"))
//        .padding()
//}
