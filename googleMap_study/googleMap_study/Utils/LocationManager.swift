//
//  LocationManager.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//


import Combine
import CoreLocation
import Foundation

enum LocationManagerError: Error, LocalizedError {
    case permissionRestricted
    case permissionDenied
    case unknownError
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()

    var didChangeAuthorizationPermission: ((CLAuthorizationStatus) -> Void)?
    var didUpdateLocation: ((CLLocationCoordinate2D) -> Void)?
    static let shared = LocationManager()

    override private init() {
        super.init()
    }

    func hasLocationTrackingPermission() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true

        default:
            return false
        }
    }
    
    func getAddressFromLatLon(coordinate: CLLocationCoordinate2D, completion: @escaping(String) -> Void) {
        print("UserLocationServices - getAddressFromLatLon() called")
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion("")
            }
            if let pm = placemarks, pm.count > 0 {
                var addressString: String = ""
                let pm = placemarks![0]
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                completion(addressString)
            }
        }
    }

    func getCurrentLocation() throws -> CLLocationCoordinate2D? {
        print("UserLocationServices - getCurrentLocation() called")
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return locationManager.location?.coordinate

        case .restricted:
            throw LocationManagerError.permissionRestricted

        case .denied:
            throw LocationManagerError.permissionDenied

        case .authorizedAlways:
            return locationManager.location?.coordinate

        case .authorizedWhenInUse:
            return locationManager.location?.coordinate

        @unknown default:
            throw LocationManagerError.unknownError
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("UserLocationServices - locationManagerDidChangeAuthorization() called")
        didChangeAuthorizationPermission?(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("UserLocationServices - locationManager() called")
        if let location = locations.first {
            didUpdateLocation?(location.coordinate)
        }
        
    }
}

