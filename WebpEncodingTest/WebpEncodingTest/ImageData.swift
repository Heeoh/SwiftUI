//
//  ImageData.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//

import Foundation
import UIKit

struct ImageData: Identifiable {
    var id = UUID()
    var image : UIImage?
    
    init(_ image: UIImage?) {
        self.image = image
    }
}

struct WebPImgData: Identifiable {
    var id = UUID()
    var webPImg : Data?
    
    init(_ webPImg: Data?) {
        self.webPImg = webPImg
    }
}
