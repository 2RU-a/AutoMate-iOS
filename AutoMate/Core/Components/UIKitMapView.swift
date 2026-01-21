//
//  UIKitMapView.swift
//  AutoMate
//
//  Created by oto rurua on 21.01.26.
//

import Foundation
import SwiftUI
import MapKit

struct UIKitMapView: UIViewRepresentable {
    // მომხმარებლის კოორდინატები (მაგალითად, თბილისი)
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UIKitMapView

        init(_ parent: UIKitMapView) {
            self.parent = parent
        }

        // აქ შეგვიძლია დავამატოთ ანოტაციების (Pin) მართვა
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }
    }
}
