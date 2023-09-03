//
//  TeleDerm2WidgetBundle.swift
//  TeleDerm2Widget
//
//  Created by Jan H. Clausen on 19/04/2023.
//

import WidgetKit
import SwiftUI

@main
struct TeleDerm2WidgetBundle: WidgetBundle {
    var body: some Widget {
        LockScreenWidget()
    }
}


struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
      // You Configuration here
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("TeleDerm2 Camera")
        .description("Open the CameraView in the TeleDerm2 app.")
        .supportedFamilies([.accessoryCircular]) // <--- Here
    }
}

