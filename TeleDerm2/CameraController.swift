//
//  CameraController.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 19/04/2023.
//

import AVFoundation
import UIKit

class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var showAlert = false
    @Published var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    @Published var imageStore = ImageStore()

    private var captureSession: AVCaptureSession?
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var photoCaptureCompletion: ((Result<UIImage, Error>) -> Void)?

    override init() {
        super.init()
        setupSession()
    }
    
    private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    private func setupSession() {
        session.sessionPreset = .photo

        do {
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("No camera found")
                return
            }

            let cameraInput = try AVCaptureDeviceInput(device: camera)

            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            }

            // Initialize photoOutput
            photoOutput = AVCapturePhotoOutput()

            if session.canAddOutput(photoOutput!) {
                session.addOutput(photoOutput!)
            }
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
        captureSession = session
    }

    func startSessionIfNeeded() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let captureSession = self.captureSession, !captureSession.isRunning {
                self.requestCameraAccess { granted in
                    if granted {
                        captureSession.startRunning()
                    } else {
                        print("Camera access denied")
                    }
                }
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func setPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
            cameraPreviewLayer = previewLayer
        }


    func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .off
            settings.isAutoStillImageStabilizationEnabled = true
            settings.isHighResolutionPhotoEnabled = false
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]

            photoOutput?.capturePhoto(with: settings, delegate: self)
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                showAlert = true
                print("Error capturing photo: \(error.localizedDescription)")
            } else if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
                let orientedImage = orientation(for: image)
                let customImage = CustomImage(image: image, orientation: orientedImage)
                DispatchQueue.main.async {
                    self.imageStore.images.append(customImage)
                }
            } else {
                showAlert = true
                print("Unknown error capturing photo")
            }
        }

        // Move this function into the CameraController
        func orientation(for image: UIImage) -> ImageOrientation {
            return image.size.width > image.size.height ? .landscape : .portrait
        }
}

enum CameraControllerError: Error {
    case unknown
}


//import AVFoundation
//import UIKit
//
//class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
//    @Published var session = AVCaptureSession()
//    @Published var showAlert = false
//    @Published var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//
//    private var captureSession: AVCaptureSession?
//    private var backCamera: AVCaptureDevice?
//    private var frontCamera: AVCaptureDevice?
//    private var currentCamera: AVCaptureDevice?
//    private var photoOutput: AVCapturePhotoOutput?
//    private var photoCaptureCompletion: ((Result<UIImage, Error>) -> Void)?
//
//    override init() {
//        super.init()
//        setupSession()
//    }
//
//    private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            DispatchQueue.main.async {
//                completion(granted)
//            }
//        }
//    }
//
//    private func setupSession() {
//        session.sessionPreset = .photo
//
//        do {
//            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//                print("No camera found")
//                return
//            }
//
//            let cameraInput = try AVCaptureDeviceInput(device: camera)
//
//            if session.canAddInput(cameraInput) {
//                session.addInput(cameraInput)
//            }
//
//            // Initialize photoOutput
//            photoOutput = AVCapturePhotoOutput()
//
//            if session.canAddOutput(photoOutput!) {
//                session.addOutput(photoOutput!)
//            }
//        } catch {
//            print("Error setting up camera input: \(error.localizedDescription)")
//        }
//        captureSession = session
//    }
//
//    func startSessionIfNeeded() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let captureSession = self.captureSession, !captureSession.isRunning {
//                self.requestCameraAccess { granted in
//                    if granted {
//                        captureSession.startRunning()
//                    } else {
//                        print("Camera access denied")
//                    }
//                }
//            }
//        }
//    }
//
//    func stopSession() {
//        if session.isRunning {
//            session.stopRunning()
//        }
//    }
//
//
//    func capturePhoto(completion: @escaping (Result<UIImage, Error>) -> Void) {
//        let settings = AVCapturePhotoSettings()
//        settings.flashMode = .off
//        settings.isAutoStillImageStabilizationEnabled = true
//        settings.isHighResolutionPhotoEnabled = false
//        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
//
//        photoOutput?.capturePhoto(with: settings, delegate: self)
//
//        self.photoCaptureCompletion = completion
//    }
//
//
////    private var photoCaptureCompletion: ((Result<UIImage, Error>) -> Void)?
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            photoCaptureCompletion?(.failure(error))
//        } else if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
//            photoCaptureCompletion?(.success(image))
//        } else {
//            photoCaptureCompletion?(.failure(CameraControllerError.unknown))
//        }
//    }
//}
//
//enum CameraControllerError: Error {
//    case unknown
//}
