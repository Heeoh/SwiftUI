//
//  ContentView.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/07.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
//    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
//    @State var images: [ImageData] = []
//    @State private var showSheet = false
    
    @StateObject var imageVM = ImageViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if imageVM.isLoading {
                    ProgressView() // 이미지 로딩 중에 표시할 로딩 인디케이터
                } else {
                    ImageView(imgList: imageVM.imgList)
                    
                    NavigationLink( destination: WebPImagesView(imgList: imageVM.imgList),
                                    label: {
                        Text("convert to WebP")
                            .foregroundColor(.black)
                            .frame(width: 200)
                            .padding(10)
                            .background(.yellow)
                            .cornerRadius(15)
                    }).padding()
                }
            }
            .onAppear {
                imageVM.loadImageData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


    /*
    Button("Select Images") {
        showSheet.toggle()
    }
    if !images.isEmpty {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(images) { imageData in
                    if let img = imageData.image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(4)
                    }
                    else {
                        Image(systemName: "photo")
                    }
                }
            }
        }
    }
}.sheet(isPresented: $showSheet) {
    CustomPhotoPickerView(imageList: $images)
}*/
