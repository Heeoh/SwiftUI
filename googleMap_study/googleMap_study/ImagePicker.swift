//
//  ImagePicker.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//

import SwiftUI
import PhotosUI

class ImagePicker: ObservableObject {
    
    @Published var images: [Image] = []
    
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
                        self.images.append(Image(uiImage: uiImage))
                        print("get image")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//struct ImagePicker: UIViewControllerRepresentable {
//
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//    }
//}

