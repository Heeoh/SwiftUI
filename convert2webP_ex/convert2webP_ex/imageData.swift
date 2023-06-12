//
//  imageData.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/11.
//

import Foundation
import UIKit
import Kingfisher

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
