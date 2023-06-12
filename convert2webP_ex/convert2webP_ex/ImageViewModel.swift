//
//  ImageViewModel.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/11.
//

import Foundation
import UIKit
import SwiftUI

class ImageViewModel: ObservableObject {
    
    let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg")!
    
    @Published var imgList: [ImageData] = []
    @Published var isLoading = true
    var totalByte : Int = 0
    
    init() {
        for _ in 0..<100 {
            imgList.append(ImageData(nil))
        }
    }
    
    // 원본 사진 바이트 수 체크
    private func getByteSize(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let originalSize = imageData.count
            totalByte += originalSize
        }
    }
        
    func loadImageData() {
        isLoading = true
        
        DispatchQueue.global(qos: .background).async {
            let group = DispatchGroup()
            
            for index in 0..<self.imgList.count {
                group.enter()
                
                let task = URLSession.shared.dataTask(with: self.imageUrl) { data, response, error in
                    defer { group.leave() }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.imgList[index].image = image
                        self.getByteSize(image: image)
                    }
                }
                task.resume()
            }
            
            group.notify(queue: .main) {
                self.isLoading = false
                print("All images loaded")
                print("Original Image Size: \(self.totalByte) bytes")
            }
        }
    }
}
