//
//  PhotoLibraryView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryView: UIViewControllerRepresentable {
    @EnvironmentObject var imageStore: ImageStore 
    @Environment(\.presentationMode) var presentationMode
    @Binding var images: [CustomImage]
    @Binding var hasImage: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images

        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.topItem?.title = "Photos"
        navigationController.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward")
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: context.coordinator, action: #selector(Coordinator.backButtonTapped))

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoLibraryView

        init(_ parent: PhotoLibraryView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let group = DispatchGroup()
            var images: [UIImage] = []

            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        images.append(image)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.parent.imageStore.images.append(contentsOf: images.map { CustomImage(image: $0, orientation: orientation(for: $0)) })
                self.parent.hasImage = !images.isEmpty
            }
        }

        @objc func backButtonTapped() {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
