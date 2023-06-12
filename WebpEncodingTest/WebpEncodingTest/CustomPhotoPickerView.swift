//
//  CustomPhotoPickerView.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/13.
//

import Foundation
import SwiftUI
import PhotosUI
import ImageIO

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var imageList: [ImageData]
    var totalByte = 0
    
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
        private var parent: CustomPhotoPickerView
        private var group = DispatchGroup() // DispatchGroup 추가
        
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
        
        // 원본 사진 바이트 수 체크
        private func getByteSize(image: UIImage) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let originalSize = imageData.count
                self.parent.totalByte += originalSize
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            for imageResult in results {
                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter() // DispatchGroup에 진입
                    imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let image = selectedImage as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.imageList.append(ImageData(image))
                                self.getByteSize(image: image)
                            }
                        }
                        self.group.leave() // 이미지 로드 완료를 알림
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("\(self.parent.imageList.count) images loaded: \(self.parent.totalByte) bytes")
            }
        }
    }

}

