//
//  ModernCameraView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 08/07/2023.
//

import SwiftUI
import UIKit

struct ModernCameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var presentationMode: PresentationMode

        init(image: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _image = image
            _presentationMode = presentationMode
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = uiImage
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, presentationMode: $presentationMode)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ModernCameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ModernCameraView>) {
    }
}
