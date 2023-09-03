//
//  EnlargedImageView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 18/04/2023.
//

import SwiftUI

struct EnlargedImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var translation: CGSize = .zero
    @State private var lastTranslation: CGSize = .zero

    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .offset(translation)
                    .animation(.easeInOut, value: scale)
                    .animation(.easeInOut, value: translation)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                translation = CGSize(width: lastTranslation.width + value.translation.width, height: lastTranslation.height + value.translation.height)
                            }
                            .onEnded { value in
                                lastTranslation = translation
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value.magnitude
                            }
                            .onEnded { value in
                                lastScale = scale
                            }
                    )
                    .simultaneousGesture(DragGesture())
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 24))
                                .modifier(ForegroundColorBasedOnBackground())
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ForegroundColorBasedOnBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? .black : .white)
            .opacity(0.9)
    }
}
