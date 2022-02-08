//
//  iOSWidget.swift
//  iOSWidget
//
//  Created by Ryan Kontos on 16/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {

    
    typealias Entry = HLLWidgetTimelineEntry
    typealias Intent = ConfigurationIntent
    
    let generator = HLLTimelineGenerator(type: .widget)
    var timeline: HLLTimeline
    
    init() {
        
        while HLLEventSource.shared.access != .Granted { print("Waiting for access ") }
        
        
        WidgetUpdateHandler.shared = WidgetUpdateHandler()
        ProStatusManager.shared = ProStatusManager()
        HLLHiddenEventStore.shared.loadHiddenEventsFromDatabase()
        HLLEventSource.shared.updateEventPool()
        
        timeline = generator.generateHLLTimeline()
        
        
    }
    
    func placeholder(in context: Context) -> Entry {
        return Entry(configuration: Intent(), underlyingEntry: HLLTimelineEntry(date: Date(), event: .previewEvent()))
    }

    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> ()) {
        
        HLLEventSource.shared.updateEventPool()
        let newTimeline = generator.generateHLLTimeline()
        let entry = Entry(configuration: configuration, underlyingEntry: newTimeline.entries.first!)
        completion(entry)
        
        
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries = [Entry]()
        HLLEventSource.shared.updateEventPool()
        let newTimeline = generator.generateHLLTimeline()
        
        HLLDefaults.widget.latestTimeline = newTimeline
        
        for entry in newTimeline.entries {
            
            entries.append(Entry(configuration: configuration, underlyingEntry: entry))
            
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
         completion(timeline)
        
    }
    
    
}

struct HLLWidgetTimelineEntry: TimelineEntry {
    
    var date: Date {
        return underlyingEntry.showAt
    }
    
    let configuration: ConfigurationIntent
    
    var state: TimelineState = .normal
    
    var underlyingEntry: HLLTimelineEntry
    
}



@main
struct HLLWidgets: WidgetBundle {
   var body: some Widget {
    CountdownWidget()
    UpcomingListWidget()
    CountdownAndUpcomingListWidget()
   }
}

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            
            CountdownWidgetParentView(entry: entry)
                .padding(.horizontal, 20)
                .modifier(HLLWidgetBackground())
        }
        .configurationDisplayName("Countdown")
        .description("Shows a countdown for a current or upcoming event. Requires How Long Left Pro.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct UpcomingListWidget: Widget {
    let kind: String = "UpcomingListWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            
            UpcomingWidgetParentView(entry: entry)
                .modifier(HLLWidgetBackground())
            
        }
        .configurationDisplayName("Upcoming")
        .description("Shows a list of upcoming events. Requires How Long Left Pro.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CountdownAndUpcomingListWidget: Widget {
    let kind: String = "CountdownAndUpcomingListWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ComboWidgetView(entry: entry)
                .modifier(HLLWidgetBackground())
            
        }
        .configurationDisplayName("Countdown & Upcoming")
        .description("Shows an event countdown and a list of upcoming events. Requires How Long Left Pro.")
        .supportedFamilies([.systemMedium])
    }
}

/*struct iOSWidget_Previews: PreviewProvider {
    static var previews: some View {
        iOSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}*/
