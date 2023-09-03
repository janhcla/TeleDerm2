//// ModernCameraView.swift
//// TeleDerm2
////
//// Created by Jan H. Clausen on 19/04/2023.
////
//
//import SwiftUI
//import AVFoundation
//
//struct ModernCameraView: View {
//    @ObservedObject private var cameraController = CameraController()
//    @Environment(\.presentationMode) private var presentationMode
//    @EnvironmentObject var imageStore: ImageStore
//    @Binding var images: [CustomImage]
//
//    @State private var capturedImage: UIImage?
//    @State private var isImageCaptured = false
//
//    var body: some View {
//            ZStack {
//                CameraPreview(cameraController: cameraController)
//                    .ignoresSafeArea(.all)
//            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }, label: {
//                        Text("Done")
//                            .font(.title3)
//                            .padding()
//                            .background(Color.white)
//                            .foregroundColor(.black)
//                            .clipShape(Capsule())
//                    })
//                    .padding(.trailing)
//                }
//                Spacer()
//
//                if isImageCaptured, let image = capturedImage {
//                    HStack {
//                        Button(action: {
//                            self.isImageCaptured.toggle()
//                            self.capturedImage = nil
//                            cameraController.startSessionIfNeeded()
//                        }, label: {
//                            Text("Retake")
//                                .font(.body)
//                                .padding()
//                                .background(Color.white)
//                                .foregroundColor(.black)
//                                .clipShape(Capsule())
//                        })
//
//                        Spacer()
//
//                        Button(action: {
//                            if let image = capturedImage {
//                                let scaledImage = image.scale(to: CGSize(width: 1024, height: 1024))
//                                let customImage = CustomImage(image: scaledImage, orientation: orientation(for: scaledImage))
//                                images.append(customImage)
//                                imageStore.images.append(customImage)
//                                self.isImageCaptured.toggle()
//                                self.capturedImage = nil
//                                cameraController.startSessionIfNeeded()
//                            }
//                        }, label: {
//                            Text("Use Photo")
//                                .font(.body)
//                                .padding()
//                                .background(Color.white)
//                                .foregroundColor(.black)
//                                .clipShape(Capsule())
//                        })
//                    }
//                    .padding()
//                } else {
//                    Button(action: {
//                        cameraController.capturePhoto()
//                        isImageCaptured = true
//                    }, label: {
//                        Image(systemName: "camera")
//                            .font(.system(size: 45))
//                            .foregroundColor(.white)
//                            .padding(20)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Circle())
//                    })
//                    .padding(.bottom)
//                }
//            }
//        }
//    
//            .onAppear {
//                // Start the camera session when the ModernCameraView appears
//                cameraController.startSessionIfNeeded()
//            }
//            .onDisappear {
//                cameraController.stopSession()
//            }
//    }
//}
//
//struct CameraPreview: UIViewRepresentable {
//    let cameraController: CameraController
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        
//        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraController.session)
//        view.layer.addSublayer(previewLayer)
//        cameraController.cameraPreviewLayer = previewLayer
//
//        // Start the camera session when the view is created
//        cameraController.startSessionIfNeeded()
//
//        return view
//    }
//
//
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//            previewLayer.videoGravity = .resizeAspectFill
//            previewLayer.frame = uiView.bounds
//        }
//    }
//
//    
//    class Coordinator: NSObject {
//        var parent: CameraPreview
//
//        init(_ parent: CameraPreview) {
//            self.parent = parent
//        }
//    }
//}
//
//
//
//
////import SwiftUI
////import AVFoundation
////
////struct ModernCameraView: View {
////    @ObservedObject private var cameraController = CameraController()
////    @Environment(\.presentationMode) private var presentationMode
////    @EnvironmentObject var imageStore: ImageStore
////    @Binding var images: [CustomImage]
////
////    @State private var capturedImage: UIImage?
////    @State private var isImageCaptured = false
////
////    var body: some View {
////        ZStack {
////            CameraPreview(cameraController: cameraController)
////                .ignoresSafeArea(.all)
////            VStack {
////                HStack {
////                    Spacer()
////                    Button(action: {
////                        presentationMode.wrappedValue.dismiss()
////                    }, label: {
////                        Text("Done")
////                            .font(.title3)
////                            .padding()
////                            .background(Color.white)
////                            .foregroundColor(.black)
////                            .clipShape(Capsule())
////                    })
////                    .padding(.trailing)
////                }
////                Spacer()
////
////                if isImageCaptured, let image = capturedImage {
////                    HStack {
////                        Button(action: {
////                            self.isImageCaptured.toggle()
////                            self.capturedImage = nil
////                            cameraController.startSessionIfNeeded()
////                        }, label: {
////                            Text("Retake")
////                                .font(.body)
////                                .padding()
////                                .background(Color.white)
////                                .foregroundColor(.black)
////                                .clipShape(Capsule())
////                        })
////
////                        Spacer()
////
////                        Button(action: {
////                            if let image = capturedImage {
////                                let scaledImage = image.scale(to: CGSize(width: 1024, height: 1024))
////                                let customImage = CustomImage(image: scaledImage, orientation: orientation(for: scaledImage))
////                                images.append(customImage)
////                                imageStore.images.append(customImage)
////                                self.isImageCaptured.toggle()
////                                self.capturedImage = nil
////                                cameraController.startSessionIfNeeded()
////                            }
////                        }, label: {
////                            Text("Use Photo")
////                                .font(.body)
////                                .padding()
////                                .background(Color.white)
////                                .foregroundColor(.black)
////                                .clipShape(Capsule())
////                        })
////                    }
////                    .padding()
////                } else {
////                    Button(action: {
////                        cameraController.capturePhoto { result in
////                            switch result {
////                            case .success(let image):
////                                self.capturedImage = image
////                                self.isImageCaptured = true
////                                cameraController.startSessionIfNeeded()
////                            case .failure(let error):
////                                print("Error capturing image: \(error.localizedDescription)")
////                            }
////                        }
////                    }, label: {
////                        Image(systemName: "camera")
////                            .font(.system(size: 45))
////                            .foregroundColor(.white)
////                            .padding(20)
////                            .background(Color.black.opacity(0.5))
////                            .clipShape(Circle())
////                    })
////                    .padding(.bottom)
////                }
////            }
////        }
////        .onAppear {
////                    cameraController.startSessionIfNeeded()
////        }
////        .onDisappear {
////                    cameraController.stopSession()
////        }
////    }
////}
////
////struct CameraPreview: UIViewRepresentable {
////    let cameraController: CameraController
////
////    func makeCoordinator() -> Coordinator {
////        Coordinator(self)
////    }
////
////    func makeUIView(context: Context) -> UIView {
////        let view = UIView()
////
////        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraController.session)
////        previewLayer.frame = view.layer.bounds
////        view.layer.addSublayer(previewLayer)
////
////        return view
////    }
////
////    func updateUIView(_ uiView: UIView, context: Context) {
////        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
////            previewLayer.frame = uiView.bounds
////        }
////    }
////
////    class Coordinator: NSObject {
////        var parent: CameraPreview
////
////        init(_ parent: CameraPreview) {
////            self.parent = parent
////        }
////    }
////}
////
////
