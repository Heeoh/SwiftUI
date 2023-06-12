//
//  WebPImagesView.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/10.
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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                
                ForEach(webPImageVM.webPImageData) { data in
                    if let webPData = data.webPImg,
                       let webPImage = UIImage(data: webPData) {
                        Image(uiImage: webPImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(4)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            // 이미지를 WebP로 변환합니다.
            
            // 비동기
            Task { await webPImageVM.convertImgListAsync(imgList: imgList) }
            
            // 동기
//             webPImageVM.convertImgListSync(imgList: imgList)
        }
    }
}

//struct WebPImagesView_Preview : PreviewProvider {
//    static var previews: some View {
//        WebPImagesView(image: Movie.getDummy().movieImage!)
//    }
//}
//
