//
//  QRCodeGenerator.swift
//  AutoMate
//
//  Created by oto rurua on 14.01.26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()
    
    static func generate(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            // სურათის გაზრდა ხარისხის დაკარგვის გარეშე
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
