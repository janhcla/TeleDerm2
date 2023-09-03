//
//  TeleDerm2App.swift
//  TeleDerm2
//
//  Created by Jan H. Clausen on 14/04/2023.
////

import SwiftUI

@main
struct TeleDerm2App: App {
    @State private var isCameraPresentedFromDeepLink: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(isCameraPresentedFromDeepLink: $isCameraPresentedFromDeepLink)
                .onOpenURL { url in
                    if url.absoluteString == "telederm2://camera" {
                        isCameraPresentedFromDeepLink = true
                    }
                }
        }
    }
}


//import SwiftUI
//
//@main
//struct TeleDerm2App: App {
//    @State private var isCameraPresentedFromDeepLink: Bool = false
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView(isCameraPresentedFromDeepLink: $isCameraPresentedFromDeepLink)
//                .onOpenURL { url in
//                    if url.absoluteString == "telederm2://camera" {
//                        isCameraPresentedFromDeepLink = true
//                    }
//                }
//        }
//    }
//}
