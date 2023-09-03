//
//  ImageStore.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 17/04/2023.
//

import SwiftUI
import UIKit

struct CustomImage: Identifiable, Equatable, Hashable {
    var id = UUID()
    var image: UIImage
    var orientation: ImageOrientation

    static func ==(lhs: CustomImage, rhs: CustomImage) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum ImageOrientation {
    case portrait
    case landscape
}

class ImageStore: ObservableObject {
    @Published var images: [CustomImage] = []
    
    func add(_ image: UIImage) {
        let orientedImage = orientation(for: image)
        let customImage = CustomImage(image: image, orientation: orientedImage)
        images.append(customImage)
    }
}


func orientation(for image: UIImage) -> ImageOrientation {
    return image.size.width > image.size.height ? .landscape : .portrait
}

