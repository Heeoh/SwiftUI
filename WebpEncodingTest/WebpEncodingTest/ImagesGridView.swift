//
//  ImagesGridView.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//

import Foundation
import SwiftUI

struct ImageGridView: View {
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
