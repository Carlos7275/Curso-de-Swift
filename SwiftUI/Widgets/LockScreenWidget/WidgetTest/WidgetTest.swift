//
//  WidgetTest.swift
//  WidgetTest
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 27/11/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetTestEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
        case .accessoryRectangular:
            if tareas.isEmpty{
                Text("No hay tareas por realizar")
            }else{
                ForEach(tareas.filter {$0.active == false } ) { item in
                    HStack{
                        Image(systemName: "square")
                        Text(item.name)
                    }
                }
            }
        case .accessoryCircular:
            VStack{
                Gauge(value: 0.50){
                    Text("\(tareas.filter {$0.active == false }.count )")
                }.gaugeStyle(.accessoryCircular)
            }
        case .accessoryInline:
            Text("\(tareas.filter {$0.active == false }.count ) tareas por hacer")
        default:
            EmptyView()
        }
    
    }
}

struct WidgetTest: Widget {
    let kind: String = "WidgetTest"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetTestEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Este es un ejemplo de widget.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline,.accessoryCircular])
    }
}

