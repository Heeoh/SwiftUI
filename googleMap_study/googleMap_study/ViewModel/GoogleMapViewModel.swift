//
//  GoogleMapViewModel.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//

import SwiftUI
import UIKit
import GoogleMaps

class GoogleMapViewModel: NSObject, ObservableObject {

    // MARK: PROPERTIES
    @Published var currentLocation: CLLocationCoordinate2D
    @Published var markers: [ImageMarker] = []
    
    var mapType: GMSMapViewType = .normal
    var isShowCurrentLocation = true
    
    @Published var selectedMarkerAddress = ""
    
    // MARK: FUNCTIONS
    
    init(currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.579617, longitude: 126.977041)) {
        print("GoogleMapViewModel - init() called")
        self.currentLocation = currentLocation
        print("currentLoc - lat: \(currentLocation.latitude), long: \(currentLocation.longitude)")
    }
    
    /// Current Location
    func getCurrentLocation() {
        print("GoogleMapViewModel - getCurrentLocation() called")
        do {
            if let currentLocation = try LocationManager.shared.getCurrentLocation() {
                self.currentLocation = currentLocation
                print("currentLoc - lat: \(currentLocation.latitude), long: \(currentLocation.longitude)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Marker tap event handler
    func getMarkerTap(_ marker: CLLocationCoordinate2D) {
        print("GoogleMapViewModel - getMarkerTap() called")
        self.currentLocation = marker
        self.selectedMarkerAddress = ""
        LocationManager.shared.getAddressFromLatLon(coordinate: marker) { address in
            self.selectedMarkerAddress = address
        }
    }
    
    func getImageMarkers(selectedImages: [ImageData]) {
//        ForEach(selectedImages) { imageData in
        for imageData in selectedImages {
            if let image = imageData.image,
               let location = imageData.location {
                self.markers.append(ImageMarker(location: location, image: image))
            }
        }
    }
}
