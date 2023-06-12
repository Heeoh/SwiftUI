//
//  CustomPhotoPickerView.swift
//  convert2webP_ex
//
//  Created by Heeoh Son on 2023/06/12.
//

import Foundation
import SwiftUI
import PhotosUI
import ImageIO

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    @Binding var imageList: [ImageData]
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 100
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: CustomPhotoPickerView
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            for imageResult in results {
                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                   imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let image = selectedImage as? UIImage {
                            // heif 사진은 안됨
                            DispatchQueue.main.async {
                                self.parent.imageList.append(ImageData(image))
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct CustomPhotoPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPhotoPickerView(selectedImage: Binding.constant(nil))
//    }
//}
