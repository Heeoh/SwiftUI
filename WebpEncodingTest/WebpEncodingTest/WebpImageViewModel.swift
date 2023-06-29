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

// test용!!!!-------------------------------------------------------//
var totalByte: Int = 0
var resizingTimeSum : TimeInterval = 0
var encodingTimeSum : TimeInterval = 0

func getElapsedTime(start: Date) -> TimeInterval {
    let end = Date()
    let elapsedTime = end.timeIntervalSince(start)
    return elapsedTime
}

func testing(start : Date?, type : String) {
    
    guard let startTime = start else { return }
    let elapsedTime = getElapsedTime(start: startTime)
    
    switch (type) {
    case "resizing" :
        print("image resized: \(elapsedTime) 초")
        resizingTimeSum += elapsedTime
    case "encoding" :
        print("An image converted to WebP: \(elapsedTime) 초")
        encodingTimeSum += elapsedTime
    default :
        return
    }
    
}
//----------------------------------------------------------------//

class webPImageViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    /// 변환한 webp 이미지들
    var webPImageData: [Data] = []
    
    /// 변환 진행 상태
    @Published var isLoading = true
    

    // MARK: FUNCS - RESIZING
    
    
    /// Core Graphics를 이용해 image resizing
    func resizeImageAsync(image: UIImage) async -> UIImage? {
        let maxSize: CGFloat = 1024

        // 이미지의 짧은 부분이 1024가 되도록 리사이징
        let scaleFactor = max(maxSize / image.size.width, maxSize / image.size.height)

        // 이미지 크기가 1024 이하인 경우 축소하지 않고 반환
        if scaleFactor >= 1.0 {
            return image
        }

        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let scaledWidth = image.size.width * scaleFactor
                let scaledHeight = image.size.height * scaleFactor
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
                
                guard let context = CGContext(data: nil,
                                              width: Int(scaledWidth), height: Int(scaledHeight),
                                              bitsPerComponent: 8, bytesPerRow: 0,
                                              space: colorSpace, bitmapInfo: bitmapInfo)
                else { return continuation.resume(returning: nil) }

                context.interpolationQuality = .high
                context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))

                guard let scaledImage = context.makeImage() else {
                    return continuation.resume(returning: nil)
                }

                let resizedImage = UIImage(cgImage: scaledImage)
                
//                testing(start: startDate, type: "resizing")
                continuation.resume(returning: resizedImage)
            }
        }
    }

   
    // MARK: FUNC - ASYNC ENCODING
    
    /// 하나의 uiImage를 webp로 변환
    /// uiImage가 없거나 변환에 실패했을 경우 nil 리턴
    func convertImageToWebPAsync(image: UIImage) async -> Data? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                if let webPData: Data = try? WebPEncoder().encode(image, config: .preset(.picture, quality: 90)) {
                    continuation.resume(returning: webPData)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    /// 여러 개의 uiImage를 알맞은 사이즈로 리사이징 후 webp로 변환
    /// 각 이미지에 대해 비동기 병렬로 작업 수행
    func convertImgListAsync(imgList: [UIImage]) async {
        // 이미 모든 이미지가 변환되어 있는 경우
        if !webPImageData.isEmpty && webPImageData.count == imgList.count {
            print("All images already converted")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // test !!!
        let startDate = Date()
        
        // 현재 webpImageData는 항상 []로 초기화되어 있음
        // 변환시킬 이미지 개수만큼 webPImageData 배열 초기화
//        webPImageData = Array(repeating: WebPImgData(nil), count: imgList.count)
        
        // webP로 변환
        await withTaskGroup(of: Void.self) { group in
            // Add each image conversion task to the group
            for uiImage in imgList {
                group.addTask {
//                    if let uiImage = imageData,
                    if let resizedImage = uiImage.resizeAsync(maxSize: 1024),
//                       let resizedImage = await self.resizeImageAsync(image: uiImage),
                       let webPData = await self.convertImageToWebPAsync(image: resizedImage) {
                        Task {
//                            self.webPImageData[i].webPImg = webPData
                            self.webPImageData.append(webPData)
                            // test !!!
                            totalByte += webPData.count
                            let byteArray = [UInt8](webPData)
                            //await self.uploadImageToServer(webPData: webPData) // 이미지를 변환한 후 바로 서버로 업로드
                        }
                    }
                }
            }
        
            await group.waitForAll()
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        
        print("\(webPImageData.count) images converted to WebP:  \(totalByte) bytes")
        print("Time: \(getElapsedTime(start: startDate)) 초")
    }
    
    // MARK: WEBP TO SERVER

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

extension UIImage {
func resizeAsync(maxSize: CGFloat) -> UIImage? {
    let scaleFactor = max(maxSize / self.size.width, maxSize / self.size.height)
    
    if scaleFactor >= 1.0 {
        return self
    }
    
//        return await withCheckedContinuation { continuation in
//            DispatchQueue.global().async {
    let scaledWidth = self.size.width * scaleFactor
    let scaledHeight = self.size.height * scaleFactor
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    
    guard let context = CGContext(data: nil,
                                  width: Int(scaledWidth), height: Int(scaledHeight),
                                  bitsPerComponent: 8, bytesPerRow: 0,
                                  space: colorSpace, bitmapInfo: bitmapInfo)
    else { return nil }
//        else { return continuation.resume(returning: nil) }
    
    context.interpolationQuality = .high
    context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
    
    guard let scaledImage = context.makeImage() else {
        return nil
//            return continuation.resume(returning: nil)
    }
    
    let resizedImage = UIImage(cgImage: scaledImage)
    return resizedImage
//        return continuation.resume(returning: resizedImage)
//            }
//        }
}
}
