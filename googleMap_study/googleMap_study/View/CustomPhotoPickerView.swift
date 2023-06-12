//
//  CustomPhotoPickerView.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [ImageData]
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        print("CustomPhotoPickerView - makeUIViewController() called")
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        print("CustomPhotoPickerView - updateUIViewController() called")
    }
    
    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        print("CustomPhotoPickerView - makeCoordiantor() called")
        return Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("CustomPhotoPicker - Coordinator - picker() called")
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            for imageResult in results {
                var newImageData = ImageData()
                if let assetId = imageResult.assetIdentifier {
                    let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                    
                    DispatchQueue.main.async {
                        newImageData.date = assetResults.firstObject?.creationDate
                        newImageData.location = assetResults.firstObject?.location?.coordinate
                    }
                }
                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                newImageData.image = selectedImage as? UIImage
                            }
                            self.parent.selectedImages.append(newImageData)
//                            print("newImageData - location: \(newImageData.location?.latitude), \(newImageData.location?.longitude)")
                        }
                    }
                }
            }
        }
        
        private let parent: CustomPhotoPickerView
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
    }
}

//struct CustomPhotoPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPhotoPickerView()
//    }
//}
