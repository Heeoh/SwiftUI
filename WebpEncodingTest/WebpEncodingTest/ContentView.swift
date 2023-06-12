//
//  ContentView.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var images: [ImageData] = []
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Select Images") {
                    showSheet.toggle()
                }
                if !images.isEmpty {
                    ImageGridView(imgList: images)

                    NavigationLink( destination: WebPImagesView(imgList: images),
                                    label: {
                        Text("convert to WebP")
                            .foregroundColor(.black)
                            .frame(width: 200)
                            .padding(10)
                            .background(.yellow)
                            .cornerRadius(15)
                    }).padding()

                }
            }.sheet(isPresented: $showSheet) {
                CustomPhotoPickerView(imageList: $images)
            }
                 
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



