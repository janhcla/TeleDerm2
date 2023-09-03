//
//  TeleDerm2Widget.swift
//  TeleDerm2Widget
//
//  Created by Jan H. Clausen on 19/04/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var widgetType

    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch widgetType {
            case .accessoryCircular:
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .widgetURL(URL(string: "telederm2://camera"))
            default:
                Text("No Data Available")
            }
        }
        else {
            EmptyView()
        }
    }
}
