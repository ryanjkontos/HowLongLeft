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
    
    #if os(iOS)
    typealias Intent = HLLWidgetConfigurationIntent
    #else
    typealias Intent = ConfigurationIntent
    #endif
    
    
    let configStore = WidgetConfigurationStore()
    var generator = HLLTimelineGenerator(type: .widget)

    let storageManager = WidgetHLLTimelineStorageManager()
    
    init() {
        
        //HLLDataModel.shared = HLLDataModel()
        
        while HLLEventSource.shared.access != .Granted { print("Waiting for access ") }
        
        WidgetUpdateHandler.shared = WidgetUpdateHandler()
        ProStatusManager.shared = ProStatusManager()
        HLLHiddenEventStore.shared.loadHiddenEventsFromDatabase()
        HLLEventSource.shared.updateEventPool()
        
    
        
        
    }
    
    func placeholder(in context: Context) -> Entry {
        return Entry(configuration: Intent(), underlyingEntry: HLLTimelineEntry(date: Date(), event: .previewEvent()))
    }

    
    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> ()) {
        
        generator.reset()
        
        var config: HLLTimelineConfiguration?
        
        #if os(iOS)
        
        if let intentConfig = configuration.config {
            config = configStore.getConfigFromIntent(intent: intentConfig)
        }
        
        #endif
        
        
        HLLEventSource.shared.updateEventPool()
        generator.timelineConfiguration = config
        let newTimeline = generator.generateHLLTimeline()
        let entry = Entry(configuration: configuration, underlyingEntry: newTimeline.entries.first!)
        completion(entry)
        
        
    }

    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        generator.reset()
        
        var config: HLLTimelineConfiguration?
        
        if configuration.useConfig?.boolValue ?? true {
            
            config = configStore.defaultGroup
            
            if let intentConfig = configuration.config, let match = configStore.getConfigFromIntent(intent: intentConfig) {
                config = match
            }
            
        } else {
            
            if let widgetEvent = configuration.enabledEvents {
                generator.onlyShowEventID = widgetEvent.identifier
            } else {
                generator.onlyShowEventID = ""
            }
            
        }
        
        var entries = [Entry]()
        HLLEventSource.shared.updateEventPool()
        generator.timelineConfiguration = config
        let newTimeline = generator.generateHLLTimeline()
        
        storageManager.saveTimeline(newTimeline, configID: config?.id)
        
        for entry in newTimeline.entries {
            
            entries.append(Entry(configuration: configuration, underlyingEntry: entry))
            
        }
        
        var array = HLLDefaults.defaults.stringArray(forKey: "WidgetUpdates") ?? [String]()
        array.append(String(Date().timeIntervalSinceReferenceDate))
        HLLDefaults.defaults.set(array, forKey: "WidgetUpdates")
        
        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(30*60)))
        completion(timeline)
        
    }
    
    
}

struct HLLWidgetTimelineEntry: TimelineEntry {
    
    var date: Date {
        return underlyingEntry.showAt
    }
    
    let configuration: Provider.Intent
    
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
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider()) { entry in
            
            CountdownWidgetParentView(entry: entry, progressBarEnabled: entry.configuration.ProgressBar?.boolValue ?? true)
                .padding(.horizontal, 20)
                .modifier(HLLWidgetBackground())
        }
        .configurationDisplayName("Countdown")
        #if os(macOS)
        .description("Shows a countdown for a current or upcoming event. Requires How Long Left Pro.")
        #else
        .description("Shows a countdown for a current or upcoming event. Requires purchase.")
        #endif
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct UpcomingListWidget: Widget {
    let kind: String = "UpcomingListWidget"

    var body: some WidgetConfiguration {
        
        
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider()) { entry in
            
            UpcomingWidgetParentView(entry: entry)
                .modifier(HLLWidgetBackground())
            
        }
        .configurationDisplayName("Upcoming")
        #if os(macOS)
        .description("Shows a list of upcoming events. Requires How Long Left Pro.")
        #else
        .description("Shows a list of upcoming events. Requires purchase.")
        #endif
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CountdownAndUpcomingListWidget: Widget {
    let kind: String = "CountdownAndUpcomingListWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider()) { entry in
            ComboWidgetView(entry: entry)
                .modifier(HLLWidgetBackground())
            
        }
        .configurationDisplayName("Countdown & Upcoming")
        #if os(macOS)
        .description("Shows an event countdown and a list of upcoming events. Requires How Long Left Pro.")
        #else
        .description("Shows an event countdown and a list of upcoming events. Requires purchase.")
        #endif
        .supportedFamilies([.systemMedium])
    }
}

/*struct iOSWidget_Previews: PreviewProvider {
    static var previews: some View {
        iOSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}*/
