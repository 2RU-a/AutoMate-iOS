//
//  QRCodeView.swift
//  AutoMate
//
//  Created by oto rurua on 12.01.26.
//

import SwiftUI

struct QRCodeView: View {
    let vinCode: String // აქ გადაეცემა მანქანის VIN კოდი
    
    var body: some View {
        VStack(spacing: 10) {
            
            let qrImage = QRCodeGenerator.generate(from: vinCode)
            
            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            
            Text("VIN: \(vinCode)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

//#Preview {
//    // სატესტო VIN კოდი
//    QRCodeView(vinCode: "ABC123456789")
//}
