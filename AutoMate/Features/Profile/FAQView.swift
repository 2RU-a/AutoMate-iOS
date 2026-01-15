//
//  FAQView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import Foundation
import SwiftUI

struct FAQView: View {
    let faqs = [
        (q: "როგორ დავამატო მანქანა?", a: "გადადით 'ჩემი მანქანა' ტაბზე და დააჭირეთ პლუს ღილაკს."),
        (q: "როგორ შევცვალო მისამართი?", a: "პროფილის გვერდზე დააჭირეთ რედაქტირებას (მალე დაემატება)."),
        (q: "რა არის AutoMate-ის უპირატესობა?", a: "თქვენი მანქანის სრული ისტორია ერთ სივრცეში.")
    ]
    
    var body: some View {
        List(faqs, id: \.q) { faq in
            DisclosureGroup(faq.q) {
                Text(faq.a)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
            }
        }
        .navigationTitle("FAQ")
    }
}
