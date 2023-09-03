//
//  PhotosView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
//

//
//  PhotosView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
//

//
//  PhotosView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
//

import SwiftUI

struct PhotosView: View {
    @EnvironmentObject var imageStore: ImageStore
    @Binding var images: [CustomImage]
    @State private var navigateToRenamePhotosView: Bool = false
    @State private var editMode: Bool = false
    @State private var markedIndices: Set<Int> = []
    @State private var showEnlargedImage: Bool = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ZStack {
            Form {
                Section {
                    ScrollView(.vertical) {
                        LazyVStack {
                            let doubleColumn: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
                            let chunkSize = 2

                            ForEach(imageStore.images.chunked(into: chunkSize), id: \.self) { chunk in
                                imageGrid(chunk: chunk, columns: doubleColumn)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Images")
            .navigationBarItems(trailing: Button(action: { editMode.toggle() }) {
                Text(editMode ? "Done" : "Edit")
            })

            VStack {
                Spacer()
                if editMode {
                    Button(action: {
                        deleteMarkedPhotos()
                    }) {
                        Text("Delete")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250, height: 50)
                    }
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                } else if !imageStore.images.isEmpty {
                    Button(action: {
                        navigateToRenamePhotosView = true
                    }) {
                        Text("Accept")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(NavigationLink("", destination: RenamePhotosView(images: $imageStore.images).environmentObject(imageStore), isActive: $navigateToRenamePhotosView) // Add this modifier here
                                .hidden())
                    }
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showEnlargedImage) {
            if let image = selectedImage {
                EnlargedImageView(image: $selectedImage)

            }
        }
    }

    private func imageGrid(chunk: [CustomImage], columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns) {
            ForEach(chunk.indices, id: \.self) { index in
                let imageIndex = imageStore.images.firstIndex(of: chunk[index])!
                imageCell(index: imageIndex, image: chunk[index].image)
            }
        }
    }
    
    private func imageCell(index: Int, image: UIImage) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
                .padding(2)
                .onTapGesture {
                    handleTap(index: index)
                }

            if editMode && markedIndices.contains(index) {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)

                Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .padding(2)
                }
            }
        }

        private func handleTap(index: Int) {
            if editMode {
                if markedIndices.contains(index) {
                    markedIndices.remove(index)
                } else {
                    markedIndices.insert(index)
                }
            } else {
                selectedImage = imageStore.images[index].image
                showEnlargedImage.toggle()
            }
        }
        
        private func deleteMarkedPhotos() {
            for index in markedIndices.sorted().reversed() {
                imageStore.images.remove(at: index)
            }
            markedIndices.removeAll()
        }
    }

    extension Array {
        func chunked(into size: Int) -> [[Element]] {
            stride(from: 0, to: count, by: size).map {
                Array(self[$0 ..< Swift.min($0 + size, count)])
            }
        }
    }
