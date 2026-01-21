//
//  MultiLineTextField.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import Foundation
import SwiftUI
import UIKit

struct MultiLineTextField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // მხოლოდ მაშინ ვაახლებთ, თუ ტექსტი რეალურად შეიცვალა
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultiLineTextField

        init(_ parent: MultiLineTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            // ყოველი სიმბოლოს აკრეფისას ვაახლებთ SwiftUI-ს @State-ს
            parent.text = textView.text
        }
    }
}
