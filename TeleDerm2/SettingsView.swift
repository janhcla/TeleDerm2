//
//  SettingsView.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("ipAddress") private var ipAddress: String = ""
    @AppStorage("path") private var path: String = ""
    @AppStorage("username") private var username: String = ""
    @AppStorage("password") private var password: String = ""
    @State private var isPresented: Bool = false
    
    // A computed property that returns true if any of the four variables is empty
    private var canSave: Bool {
        !(ipAddress.isEmpty || path.isEmpty || username.isEmpty || password.isEmpty)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("IP Address of the server")) {
                    TextField("IP Address", text: $ipAddress)
                        .autocapitalization(.none)
                }
                Section(header: Text("Path to the upload directory")) {
                    TextField("Path", text: $path)
                        .autocapitalization(.none)
                }
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                }
                Section(header: Text("Password")) {
                    SecureField("Password", text: $password)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                // Save the values to AppStorage
                                self.isPresented = true
                            },
                            label: {
                                Text("Save")
                            }
                        )
                        .disabled(!canSave) // Use the computed property here
                        .alert(isPresented: $isPresented) { // Show an alert when the button is tapped
                            Alert(
                                title: Text("Saved"),
                                message: Text("Your settings have been saved."),
                                dismissButton: .default(Text("OK"), action: {
                                    presentationMode.wrappedValue.dismiss()
                                })
                            )
                        }
                        Spacer()
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                // Reset the values to empty strings
                                ipAddress = ""
                                path = ""
                                username = ""
                                password = ""
                            },
                            label: {
                                Text("Reset")
                            }
                        )
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
}


//import SwiftUI
//
//struct SettingsView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @AppStorage("ipAddress") private var savedIPAddress: String = ""
//    @AppStorage("path") private var savedPath: String = ""
//    @AppStorage("username") private var savedUsername: String = ""
//    @AppStorage("password") private var savedPassword: String = ""
//    @State private var isPresented: Bool = false
//
//    @State private var ipAddress: String
//    @State private var path: String
//    @State private var username: String
//    @State private var password: String
//
//    init() {
//        _ipAddress = State(initialValue: UserDefaults.standard.string(forKey: "ipAddress") ?? "")
//        _path = State(initialValue: UserDefaults.standard.string(forKey: "path") ?? "")
//        _username = State(initialValue: UserDefaults.standard.string(forKey: "username") ?? "")
//        _password = State(initialValue: UserDefaults.standard.string(forKey: "password") ?? "")
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("IP Address of the server")) {
//                    TextField("IP Address", text: $ipAddress)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Path to the upload directory")) {
//                    TextField("Path", text: $path)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Username")) {
//                    TextField("Username", text: $username)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Password")) {
//                    SecureField("Password", text: $password)
//                }
//
//                Section {
//                    HStack {
//                        Spacer()
//                        Button("Reset", action: resetFields)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .background(Color.red)
//                            .cornerRadius(10)
//                        Spacer()
//                        Button("Save", action: saveFields)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .background(Color.green)
//                            .cornerRadius(10)
//                        Spacer()
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                Section {
//                    Text("(c) Copyright Jan H. Clausen, Midtbylægerne. 2023. All rights reserved.")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//            }
//
//
//                .navigationTitle("Settings")
//
//        }
//        .alert(isPresented: $isPresented) {
//            Alert(title: Text("Saved"), message: Text("Your settings have been saved."), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    private func resetFields() {
//        ipAddress = ""
//        path = ""
//        username = ""
//        password = ""
//    }
//
//    private func saveFields() {
//        savedIPAddress = ipAddress
//        savedPath = path
//        savedUsername = username
//        savedPassword = password
//        isPresented = true
//        presentationMode.wrappedValue.dismiss()
//    }
//}
//

//
//import SwiftUI
//
//struct SettingsView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @AppStorage("ipAddress") private var savedIPAddress: String = ""
//    @AppStorage("path") private var savedPath: String = ""
//    @AppStorage("username") private var savedUsername: String = ""
//    @AppStorage("password") private var savedPassword: String = ""
//    @State private var isPresented: Bool = false
//
//    @State private var ipAddress: String = ""
//    @State private var path: String = ""
//    @State private var username: String = ""
//    @State private var password: String = ""
//
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("IP Address of the server")) {
//                    TextField("IP Address", text: $ipAddress)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Path to the upload directory")) {
//                    TextField("Path", text: $path)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Username")) {
//                    TextField("Username", text: $username)
//                        .autocapitalization(.none)
//                }
//                Section(header: Text("Password")) {
//                    SecureField("Password", text: $password)
//                }
//
//                Section {
//                    HStack {
//                        Spacer()
//                        Button("Reset", action: resetFields())
////                        Button(action: {
////                            resetFields()
////                        })
////                        {
////                            Text("Reset")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .background(Color.red)
//                                .cornerRadius(10)
//
////                        }
//                        Spacer()
//                        Button("Save", action: saveFields())
////                        Button(action: {
////                            saveFields()
////                        })
////                        {
////                            Text("Save")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .background(Color.green)
//                                .cornerRadius(10)
////                        }
//                        Spacer()
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                Section {
//                    Text("(c) Copyright Jan H. Clausen, Midtbylægerne. 2023. All rights reserved.")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//            }
//
//
//                .navigationTitle("Settings")
//        }
//
//        .alert(isPresented: $isPresented) {
//                    Alert(title: Text("Saved"), message: Text("Your settings have been saved."), dismissButton: .default(Text("OK")))
//                }
//
//        }
//
//    private func resetFields() {
//        ipAddress = ""
//        path = ""
//        username = ""
//        password = ""
//
//        savedIPAddress = ipAddress
//        savedPath = path
//        savedUsername = username
//        savedPassword = password
//        isPresented = false
//    }
//
//    private func saveFields() {
//        savedIPAddress = ipAddress
//        savedPath = path
//        savedUsername = username
//        savedPassword = password
//        isPresented = true
//        presentationMode.wrappedValue.dismiss()
//    }
//}



//import SwiftUI
//
//struct SettingsView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @AppStorage("ipAddress") private var savedIPAddress: String = ""
//    @AppStorage("path") private var savedPath: String = ""
//    @AppStorage("username") private var savedUsername: String = ""
//    @AppStorage("password") private var savedPassword: String = ""
//    @State private var showAlert: Bool = false
//
//    @State private var ipAddress: String = ""
//    @State private var path: String = ""
//    @State private var username: String = ""
//    @State private var password: String = ""
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("IP Address of the server")) {
//                                TextField("IP Address", text: $ipAddress)
//                                    .autocapitalization(.none)
//                            }
//                            Section(header: Text("Path to the upload directory")) {
//                                TextField("Path", text: $path)
//                                    .autocapitalization(.none)
//                            }
//                            Section(header: Text("Username")) {
//                                TextField("Username", text: $username)
//                                    .autocapitalization(.none)
//                            }
//                            Section(header: Text("Password")) {
//                                SecureField("Password", text: $password)
//                            }
//
//                Section {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            savedIPAddress = ""
//                            savedPath = ""
//                            savedUsername = ""
//                            savedPassword = ""
//                        }) {
//                            Text("Reset")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .background(Color.red)
//                                .cornerRadius(10)
//
//                        }
//                        Spacer()
//                        Button(action: {
//                            savedIPAddress = ipAddress
//                            savedPath = path
//                            savedUsername = username
//                            savedPassword = password
//                            self.showAlert = true
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Text("Save")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .background(Color.green)
//                                .cornerRadius(10)
//
//                        }
//                        Spacer()
//
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                Section {
////                    HStack {
////                        Spacer()
//                        Text("(c) Copyright Jan H. Clausen, Midtbylægerne. 2023. All rights reserved.")
//                                            .font(.footnote)
//                                            .foregroundColor(.secondary)
////                                            .padding([.bottom, .trailing], 16)
//
//                }
//            }
//            .onAppear {
//                        ipAddress = savedIPAddress
//                        path = savedPath
//                        username = savedUsername
//                        password = savedPassword
//            }
//            .navigationTitle("Settings")
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Saved"), message: Text("Your settings have been saved."), dismissButton: .default(Text("OK"), action: {
//                    presentationMode.wrappedValue.dismiss()
//                }))
//            }
//        }
//    }
//}
//
