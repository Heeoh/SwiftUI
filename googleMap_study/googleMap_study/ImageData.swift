//
//  ImageData.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//

import SwiftUI
import CoreLocation

struct ImageData : Identifiable {
    var id = UUID()
    var image: UIImage?
    var date: Date?
    var location: CLLocationCoordinate2D?
}
