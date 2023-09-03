//
//  EditPhotosView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 16/04/2023.
//

import SwiftUI

struct EditPhotosView: View {
    @EnvironmentObject var imageStore: ImageStore
    @Binding var images: [CustomImage]
    @State private var selectedIndices: Set<Int> = []
    
    var body: some View {
        VStack {
            Text("Edit Photos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                    ForEach(imageStore.images.indices, id: \.self) { index in
                        ZStack {
                            Image(uiImage: imageStore.images[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .cornerRadius(10)
                                .overlay(selectedIndices.contains(index) ? Color.black.opacity(0.5) : Color.clear)
                            
                            if selectedIndices.contains(index) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            if selectedIndices.contains(index) {
                                selectedIndices.remove(index)
                            } else {
                                selectedIndices.insert(index)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                deleteMarkedPhotos()
            }) {
                Text("Delete marked photos")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing, .bottom])
        }
    }
    
    private func deleteMarkedPhotos() {
        selectedIndices.sorted(by: >).forEach { imageStore.images.remove(at: $0) }
        selectedIndices.removeAll()
    }
}
