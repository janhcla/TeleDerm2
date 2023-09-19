// ContentView.swift
// TeleDerm2
//
// Created by Jan H. Clausen on 14/04/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var imageStore = ImageStore()
    @State private var hasImage = false
    @State private var showPhotoLibrary = false
    @State private var isCameraViewPresented = false
    @State private var images: [CustomImage] = []
    @State private var capturedImage: UIImage? = nil  // New line to store the captured image
    
    @Binding var isCameraPresentedFromDeepLink: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isCameraViewPresented = true
                    
                }) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 80, height: 60)
                        Text("Take a picture")
                    }
                    .sheet(isPresented: $isCameraViewPresented) {
                        ModernCameraView(image: $capturedImage)  // Modified line
                            .environmentObject(imageStore)
                            .onDisappear {
                                if let captured = capturedImage {
                                    imageStore.add(captured)
                                }
                            }
                    }
                    .padding()
                }
                
                Button(action: {
                    showPhotoLibrary.toggle()
                }) {
                    VStack {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 80, height: 60)
                        Text("Choose from library")
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $showPhotoLibrary) {
                    PhotoLibraryView(images: $imageStore.images, hasImage: $hasImage).environmentObject(imageStore)
                }
                
                if hasImage {
                    NavigationLink(destination: PhotosView(images: $imageStore.images).environmentObject(imageStore)) {
                        VStack {
                            Image(systemName: "photo.on.rectangle.fill")
                                .resizable()
                                .frame(width: 80, height: 60)
                            Text("Continue to view the photos")
                        }
                    }
                    .foregroundColor(Color.green)
                    .padding()
                }
            }

                .onAppear {
                    if isCameraPresentedFromDeepLink {
                        isCameraViewPresented = true
                        isCameraPresentedFromDeepLink = false
                    }
                }
                .onChange(of: imageStore.images) { _ in
                    if imageStore.images.isEmpty {
                        hasImage = false
                    } else {
                        hasImage = true
                    }
                }
                .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                })
                .navigationBarBackButtonHidden(true)
            
        }
    }
}
extension Notification.Name {
    static let didTakePhoto = Notification.Name("didTakePhoto")
    static let didSelectPhoto = Notification.Name("didSelectPhoto")
}
