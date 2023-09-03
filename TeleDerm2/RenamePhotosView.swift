// RenamePhotosView.swift
// TeleDerm2
//
// Created by Jan H. Clausen on 14/04/2023.
//

import SwiftUI
import Alamofire

struct ErrorMessage: Equatable, Identifiable { // Added Identifiable conformance
    let id = UUID() // Added this property
    let title: String?
    let message: String?
    var joinedTitle: String {
        (title ?? "") + "\n\n" + (message ?? "")
    }
    static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        lhs.title == rhs.title && lhs.message == rhs.message
    }
}

struct Message: Identifiable { // Added this struct
    let id = UUID()
    let text: String
}

// Declare a class to store the request
class RequestManager: ObservableObject {
    @Published var request: DataRequest?
}

struct RenamePhotosView: View {
    @EnvironmentObject var imageStore: ImageStore
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @Binding var images: [CustomImage]
    @AppStorage("ipAddress") private var ipAddress: String = ""
    @AppStorage("path") private var path: String = ""
    @AppStorage("username") private var username: String = ""
    @AppStorage("password") private var password: String = ""
    @State private var uploadProgress: Double = 0
    @State private var isUploading: Bool = false
    @State private var isCancelled: Bool = false
    @State private var showAlert: Bool = false // Add this property
    @State private var errorMessage: ErrorMessage? // Add this property
    @State private var message: Message? // Add this property
    @ObservedObject var requestManager = RequestManager()
    
    // ...
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rename your photos")) {
                    TextField("Name", text: $name)
                        .autocapitalization(.none)
                }
                Section {
                    if isUploading {
                     ProgressView(value: uploadProgress, total: Double(imageStore.images.count))
                     .progressViewStyle(CircularProgressViewStyle())
                    } else {
                     Text("Ready to upload")
                    }
                    Button(action: {
                        isCancelled = false // Reset the value here
                        uploadProgress = 0 // Reset the value here
                        isUploading = true
                        uploadPhotos()
                    }) {
                        HStack {
                            Spacer()
                            Text("Accept and upload")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color.blue)
                            Spacer()
                        }
                    }
                    .buttonStyle(.bordered) // Added this modifier
                    Button(action: { // Add this button
                        isCancelled = true
                        message = Message(text: "Upload canceled") // Set the message here
                        Alamofire.Session.default.cancelAllRequests() // Cancel all requests here
                    }) {
                        HStack {
                            Spacer()
                            Text("Cancel upload")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color.red)
                            Spacer()
                        }
                    }
                    .buttonStyle(.bordered) // Added this modifier
                }
            }
            // .navigationBarTitle(Text("Rename Photos"), displayMode: .inline)
            // Add an alert modifier to show the error message
            .alert(item: $errorMessage) { error in
                Alert(
                    title: Text("Upload failed"),
                    message: Text(error.message ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            // Add an alert modifier to show the message as an item
            .alert(item: $message) { message in
                Alert(
                    title: Text(message.text),
                    dismissButton: .default(Text("OK")) {
                        // Reset the variables here
                        isUploading = false
                        isCancelled = false
                        uploadProgress = 0
                        errorMessage = nil
                        // Reload the view here (optional)
                    }
                )
            }
        }
    }
    
    private func uploadPhotos() {
        for (index, customImage) in imageStore.images.enumerated() {
            if isCancelled { // Check if cancelled
                requestManager.request?.cancel() // Cancel the request
                break // Break out of the loop
            }
            let imageData = customImage.image.jpegData(compressionQuality: 0.5)!
            let fileName = name + "_\(index + 1).jpg"
            let url = "http://\(ipAddress)/\(path)/\(fileName)"
            
            // Assign the request to the variable
            requestManager.request = AF.upload(imageData, to: url, method: .put)
                .authenticate(username: username, password: password)
                .uploadProgress { progress in
                 print("Upload Progress \(progress.fractionCompleted)")
                 self.uploadProgress += progress.fractionCompleted
                 }
                        .responseString { response in
                            print(response.result)
                            switch response.result { // Changed to switch statement
                            case .success(let value):
                                print("Alamo value \(value)")
                                if index == imageStore.images.count - 1 {
                                    if !isCancelled { // Check if cancelled
                                        self.showAlert = true // Set this to true
                                    } else {
                                        // Handle cancellation here (optional)
                                        print("Upload cancelled")
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            case .failure(let error):
                                print("Alamo error \(error)")
                                self.errorMessage = ErrorMessage(title: nil, message: error.errorDescription) // Set error message
                                return // Return from function
                            }
                        }
                }
        }
    }


//import SwiftUI
//import Alamofire
//
//
//struct ErrorMessage: Equatable, Identifiable { // Added Identifiable conformance
//    let id = UUID() // Added this property
//    let title: String?
//    let message: String?
//    var joinedTitle: String {
//        (title ?? "") + "\n\n" + (message ?? "")
//    }
//    static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
//        lhs.title == rhs.title && lhs.message == rhs.message
//    }
//}
//
//// Declare a class to store the request
//class RequestManager: ObservableObject {
//    @Published var request: DataRequest?
//}
//
//struct RenamePhotosView: View {
//    @EnvironmentObject var imageStore: ImageStore
//    @Environment(\.presentationMode) var presentationMode
//    @State private var name: String = ""
//    @Binding var images: [CustomImage]
//    @AppStorage("ipAddress") private var ipAddress: String = ""
//    @AppStorage("path") private var path: String = ""
//    @AppStorage("username") private var username: String = ""
//    @AppStorage("password") private var password: String = ""
//    @State private var uploadProgress: Double = 0
//    @State private var isUploading: Bool = false
//    @State private var isCancelled: Bool = false
//    @State private var showAlert: Bool = false // Add this property
//    @State private var errorMessage: ErrorMessage? // Add this property
//    @ObservedObject var requestManager = RequestManager()
//    // Declare a state property to store the message
//    @State private var message: String?
//
//    // ...
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Rename your photos")) {
//                    TextField("Name", text: $name)
//                        .autocapitalization(.none)
//                }
//                Section {
//                    if isUploading {
//                     ProgressView(value: uploadProgress, total: Double(imageStore.images.count))
//                     .progressViewStyle(CircularProgressViewStyle())
//                    } else {
//                     Text("Ready to upload")
//                    }
//
//                    Button(action: {
//                        isCancelled = false // Reset the value here
//                        uploadProgress = 0 // Reset the value here
//                        isUploading = true
//                        uploadPhotos()
//                    }) {
//                        HStack {
//                            Spacer()
//                            Text("Accept and upload")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(width: 250, height: 50)
//                                .background(Color.blue)
//                            Spacer()
//                        }
//                    }
//
//                    Button(action: { // Add this button
//                        isUploading = false
//                        isCancelled = true
//                        message = "Upload canceled" // Set the message here
//                        Alamofire.Session.default.cancelAllRequests() // Cancel all requests here
//                    }) {
//                        HStack {
//                            Spacer()
//                            Text("Cancel upload")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(width: 250, height: 50)
//                                .background(Color.red)
//                            Spacer()
//                        }
//                    }
//                }
//            }
//            // .navigationBarTitle(Text("Rename Photos"), displayMode: .inline)
//            .alert(item: $errorMessage) { error in
//                Alert(
//                    title: Text("Upload failed"),
//                    message: Text(error.message ?? "Unknown error"),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//            // Add an alert modifier to show the message
//            .alert(isPresented: $message.nonEmpty) {
//                Alert(title: Text(message ?? ""))
//            }
//        }
//    }
//
//    private func uploadPhotos() {
//        for (index, customImage) in imageStore.images.enumerated() {
//            if isCancelled { // Check if cancelled
//                requestManager.request?.cancel() // Cancel the request
//                message = "Upload canceled" // Set the message
//                break // Break out of the loop
//            }
//            let imageData = customImage.image.jpegData(compressionQuality: 0.5)!
//            let fileName = name + "_\(index + 1).jpg"
//            let url = "http://\(ipAddress)/\(path)/\(fileName)"
//
//            // Assign the request to the variable
//            requestManager.request = AF.upload(imageData, to: url, method: .put)
//                .authenticate(username: username, password: password)
//                .uploadProgress { progress in
//                    print("Upload Progress \(progress.fractionCompleted)")
//                    self.uploadProgress += progress.fractionCompleted
//                }
//                .responseString { response in
//                    print(response.result)
//                    switch response.result { // Changed to switch statement
//                    case .success(let value):
//                        print("Alamo value \(value)")
//                        if index == imageStore.images.count - 1 {
//                            if !isCancelled { // Check if cancelled
//                                self.showAlert = true // Set this to true
//                            } else {
//                                // Handle cancellation here (optional)
//                                print("Upload cancelled")
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
//                    case .failure(let error):
//                        print("Alamo error \(error)")
//                        self.errorMessage = ErrorMessage(title: nil, message: error.errorDescription) // Set error message
//                        return // Return from function
//                    }
//                }
//        }
//    }
//}
//
//// Add an extension to String? type
//extension String? {
//    var nonEmpty: Bool {
//        get {
//            self != nil && !self!.isEmpty
//        }
//        set {
//            if newValue {
//                self = self ?? ""
//            } else {
//                self = nil
//            }
//        }
//    }
//}
