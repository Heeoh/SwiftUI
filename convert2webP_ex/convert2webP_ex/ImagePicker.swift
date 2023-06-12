//
//  ImagePicker.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/10.
//

import SwiftUI
import PhotosUI

class ImagePicker: ObservableObject {
    
    @Published var images: [ImageData] = []
    
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            Task {
                if !imageSelections.isEmpty {
                    try await loadTransferable(from: imageSelections)
                    imageSelections = []
                }
            }
        }
    }
    
    func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
        print("ImagePicker - loadTransferable() called")
        do {
            for imageData in imageSelections {
                if let data = try await imageData.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.images.append(ImageData(uiImage))
//                        self.images.append(Image(uiImage: uiImage))
//                        print("get image")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
