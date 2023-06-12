//
//  GooleMapView.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//

import Foundation
import GoogleMaps
import SwiftUI
import CoreLocation
import UIKit

struct GoogleMapView: UIViewRepresentable {
    
    // MARK: PROPERTIES
    
    @Binding var currentRegionCenterLocation: CLLocationCoordinate2D
    @Binding var markers: [ImageMarker]
    var currentZoomlevel: Float = 10.0
    
    /// Show User Location
    var isMyLocationEnabled: Bool
    
    /// Map Type
    var mapType: GMSMapViewType
    
    ///  Tapped On Annotation
    var handleMarkerTapped: ((CLLocationCoordinate2D) -> Void)?
    
    /// Defaults Parameter set
    var minZoomlevel = 10.0
    var maxZoomlevel = 20.0
    
    
    // MARK: FUNCTIONS
    
    /// Creates the map view object and configures its initial state
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: context.coordinator.accessibilityFrame)
        mapView.mapType = mapType
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = isMyLocationEnabled
        mapView.setMinZoom(Float(minZoomlevel), maxZoom: Float(maxZoomlevel))
        
        mapView.camera = GMSCameraPosition(latitude: currentRegionCenterLocation.latitude, longitude: currentRegionCenterLocation.longitude, zoom: currentZoomlevel)
        return mapView
    }
    
    /// Updates the state of the specified view with new information from SwiftUI
    func updateUIView(_ view: GMSMapView, context: Context) {
        view.camera = GMSCameraPosition(latitude: currentRegionCenterLocation.latitude, longitude: currentRegionCenterLocation.longitude, zoom: currentZoomlevel)
        
        CATransaction.begin()
        CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
        let destinationPoint = GMSCameraPosition.camera(withLatitude: currentRegionCenterLocation.latitude, longitude: currentRegionCenterLocation.longitude, zoom: currentZoomlevel)
        view.animate(to: destinationPoint)
        CATransaction.commit()
        
        if markers.count > 0 {
            for item in markers {
                let position = item.location
                let markerView = UIImageView(image: item.image)
                let marker = GMSMarker(position: position)
//                marker.title = item.title
                marker.iconView = markerView
                marker.map = view
            }
        }
    }
}

// MARK: - Coordinator and Delegates
extension GoogleMapView {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, GMSMapViewDelegate {
        let parent: GoogleMapView
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            parent.handleMarkerTapped?(marker.position)
            return true
        }
    }
}
