//
//  FAQView.swift
//  AutoMate
//
//  Created by oto rurua on 16.01.26.
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
    let faqs = [
        FAQItem(question: "როგორ შევუკვეთო ნაწილები?", answer: "აირჩიეთ სასურველი პროდუქტი, დაამატეთ კალათაში და გააფორმეთ შეკვეთა 'Checkout' ღილაკით."),
        FAQItem(question: "როგორ ჩავეწერო სერვისზე?", answer: "გადადით 'ჩემი ავტომობილის' გვერდზე, აირჩიეთ თქვენი მანქანა და დააჭირეთ 'სერვისის დაჯავშნას'."),
        FAQItem(question: "რამდენ ხანში მოხდება მიწოდება?", answer: "თბილისის მასშტაბით მიწოდება ხდება 24 საათის განმავლობაში, რეგიონებში - 2-3 სამუშაო დღეში."),
        FAQItem(question: "შესაძლებელია თუ არა შეკვეთის გაუქმება?", answer: "შეკვეთის გაუქმება შესაძლებელია მანამ, სანამ მისი სტატუსი გახდება 'გზაშია'.")
    ]
    
    var body: some View {
        List {
            ForEach(faqs) { faq in
                DisclosureGroup(faq.question) {
                    Text(faq.answer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("ხშირად დასმული კითხვები")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    FAQView()
//}
