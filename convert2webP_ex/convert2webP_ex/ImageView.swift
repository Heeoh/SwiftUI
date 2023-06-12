//
//  ImageView.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/10.
//

import Foundation
import SwiftUI

struct ImageView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var imgList: [ImageData]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(imgList) { imageData in
                    if let img = imageData.image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(4)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
    }
}

//struct ImageView_Previews: PreviewProvider {
//    @StateObject var imageVM = ImageViewModel()
//
//    static var previews: some View {
//        ImageView(imgList: imageVM.imgList)
//    }
//}
