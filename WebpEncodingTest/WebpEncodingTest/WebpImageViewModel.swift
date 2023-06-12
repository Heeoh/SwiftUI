//
//  WebpImageViewModel.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//


import Foundation
import UIKit
import SwiftUI
import webp

func getElasedTime(start: Date) -> TimeInterval {
    let end = Date()
    let elapsedTime = end.timeIntervalSince(start)
    return elapsedTime
}

class webPImageViewModel: ObservableObject {
    var webPImageData: [WebPImgData] = []
    
    @Published var isLoading = true
    var totalByte: Int = 0

    
    func resizeImage(image: UIImage, idx: Int) -> UIImage? {
        let startDate = Date()
        
        let maxSize: CGFloat = 1024
        let width = image.size.width
        let height = image.size.height
        
        let scaleFactor = min(maxSize / width, maxSize / height)
        
        // 이미지 크기가 1024 이하인 경우 축소하지 않고 반환
        if scaleFactor >= 1.0 {
            return image
        }
        
        let scaledSize = CGSize(width: width * scaleFactor, height: height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        print("w: \(scaledImage.size.width), h: \(scaledImage.size.height)")
        print("image \(idx) resized: \(getElasedTime(start: startDate)) 초")
        
        return scaledImage
    }
    
    
    // MARK: ASYNCHRO CONVERT TO WEBP
    
    func convertImageToWebPAsync(uiImage: UIImage?) async -> Data? {
        guard let image = uiImage else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                //                let startDate = Date()
                if let webPData: Data = try? WebPEncoder().encode(image, config: .preset(.picture, quality: 81)) {
//                    print("An image converted to WebP: \(getElasedTime(start: startDate)) 초")
                    continuation.resume(returning: webPData)
                } else {
                    continuation.resume(returning: nil)
                }
            }

        }
    }
    
    func convertImgListAsync(imgList: [ImageData]) async {
//        self.isLoading = true
        let startDate = Date()
        
        for _ in 0..<imgList.count {
            self.webPImageData.append(WebPImgData(nil))
        }
        
        await withTaskGroup(of: (Int, Data?).self) { group in
            // Add each image conversion task to the group
            for (i, imageData) in imgList.enumerated() {
                group.addTask {
                    if let resizedImage = self.resizeImage(image: imageData.image!, idx: i),
                       let webPData = await self.convertImageToWebPAsync(uiImage: resizedImage) {
//                        print(i)
                        return (i, webPData)
                    } else {
                        return (i, nil)
                    }
                }
            }
            
            // Process each result as it completes
            for await (i, maybeData) in group {
                if let webPData = maybeData {
//                    self.webPImageData.append(WebPImgData(webPData))
                    self.webPImageData[i].webPImg = webPData
                    totalByte += webPData.count
                }
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        
        print("All images converted to WebP: \(getElasedTime(start: startDate)) 초)")
        print("WebP Image Size: \(totalByte) bytes")
    }
    
    

    /*/ not yet
    func uploadImageToServer() {
        guard let imageData = webPImageData else {
            print("변환된 이미지가 없습니다.")
            return
        }
        
        // imageData를 서버로 업로드하는 로직을 추가
        // Alamofire 라이브러리를 사용하여 업로드
    }
    */
}
    



/*
 
 func convertImageToWebP(image: UIImage) -> Data? {
     return image.sd_imageData(as: .webP, compressionQuality: 0.9)
 }

 func convertImageToByteArray(image: UIImage) -> [UInt8]? {
     guard let imageData = convertImageToWebP(image: image) else {
         return nil
     }
     
     let byteArray = [UInt8](imageData)
     return byteArray
 }
 */


