//
//  ImageMarker.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/27.
//

import UIKit
import CoreLocation

struct ImageMarker : Identifiable {
    var id = UUID()
//    var title: String
    var location: CLLocationCoordinate2D
    var image: UIImage
}

