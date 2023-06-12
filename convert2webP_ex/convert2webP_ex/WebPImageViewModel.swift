//
//  WebPImageViewModel.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/10.
//

import Foundation
import UIKit
//import SwiftUI
import SDWebImageWebPCoder

class webPImageViewModel: ObservableObject {
    @Published var webPImageData: [WebPImgData] = []
    var totalByte: Int = 0
    
    init() {
        // SDWebImageWebPCoder를 등록하여 WebP 변환 기능을 사용합니다.
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
    }
    
    func resizeImage(image: UIImage) -> UIImage? {
        let maxWidth: CGFloat = 1024
        let maxHeight: CGFloat = 1024
        
        let width = image.size.width
        let height = image.size.height
        
        let scaleFactor = min(maxWidth / width, maxHeight / height)
        
        // 이미지 크기가 1024 이하인 경우 축소하지 않고 반환
        if scaleFactor >= 1.0 {
            return image
        }
        
        let scaledSize = CGSize(width: width * scaleFactor, height: height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
    
    // MARK: ASYNCHRO CONVERT TO WEBP
    
    @MainActor
    func convertImageToWebPAsync(uiImage: UIImage?) async -> Data? {
        guard let image = uiImage else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                if let webPData = image.sd_imageData(as: .webP, compressionQuality: 0.9) {

                    continuation.resume(returning: webPData)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    @MainActor
    func convertImgListAsync(imgList: [ImageData]) async {
        let startDate = Date()
        
        await withTaskGroup(of: (Int, Data?).self) { group in
            // Add each image conversion task to the group
            for (i, imageData) in imgList.enumerated() {
                group.addTask {
                    if let webPData = await self.convertImageToWebPAsync(uiImage: self.resizeImage(image: imageData.image!)) {
                        return (i, webPData)
                    } else {
                        return (i, nil)
                    }
                }
            }
            
            // Process each result as it completes
            for await (_, maybeData) in group {
                if let webPData = maybeData {
                    self.webPImageData.append(WebPImgData(webPData))
                    totalByte += webPData.count
                }
            }
        }
        
        let endDate = Date()
        let elapsedTime = endDate.timeIntervalSince(startDate)
        
        print("All images converted to WebP")
        print("WebP Image Size: \(totalByte) bytes")
        print("변환에 걸린 시간: \(elapsedTime)초")
    }
    
    
    // MARK: SYNCHRO CONVERT TO WEBP
    func convertImageToWebPSync(uiImage: UIImage?) -> Data? {
        guard let image = uiImage else {
            return nil
        }
        
        if let webPData = image.sd_imageData(as: .webP, compressionQuality: 0.9) {
            return webPData
        } else {
            return nil
        }
    }
    
    func convertImgListSync(imgList: [ImageData]) {
        let startDate = Date()
        
        // 이미지 변환 작업 실행
        for i in 0..<imgList.count {
            if let webPData = convertImageToWebPSync(uiImage: resizeImage(image: imgList[i].image!)) {
                self.webPImageData.append(WebPImgData(webPData))
                self.totalByte += webPData.count
            }
        }
        
        let endDate = Date()
        let elapsedTime = endDate.timeIntervalSince(startDate)
        
        print("All images converted to WebP")
        print("WebP Image Size: \(totalByte) bytes")
        print("변환에 걸린 시간: \(elapsedTime)초")
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
