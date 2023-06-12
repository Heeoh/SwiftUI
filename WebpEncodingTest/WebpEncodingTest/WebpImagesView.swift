//
//  WebpImagesView.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//

import SwiftUI

struct WebPImagesView: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var imgList: [ImageData]
    @ObservedObject var webPImageVM = webPImageViewModel()

    init(imgList: [ImageData]) {
        self.imgList = imgList
    }
    
    var body: some View {
        VStack {
            if webPImageVM.isLoading {
                ProgressView()
            } else {
                Text("All images converted to webP")
            }
        }
        .onAppear {
            // 이미지를 WebP로 변환 - 비동기
            Task { await webPImageVM.convertImgListAsync(imgList: imgList) }
            
            // 이미지를 WebP로 변환 - 동기
            // webPImageVM.convertImgListSync(imgList: imgList)
        }
    }
}

