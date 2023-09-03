//
//  DisplayPhotosView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 16/04/2023.
//

import SwiftUI

struct DisplayPhotosView: View {
    @EnvironmentObject var imageStore: ImageStore
    @Binding var images: [CustomImage]

    
    var body: some View {
        VStack {
            Text("Photos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                    ForEach(imageStore.images.indices, id: \.self) { index in
                        Image(uiImage: imageStore.images[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}
