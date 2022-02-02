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


struct Provider: TimelineProvider {
    
    typealias Entry = HLLWidgetEntry
    
    let stateFetcher = WidgetStateFetcher()
    let difHandler = HLLTimelineDifHandler()
    
    init() {
        
        WidgetUpdateHandler.shared = WidgetUpdateHandler()
        ProStatusManager.shared = ProStatusManager()
        HLLHiddenEventStore.shared.loadHiddenEventsFromDatabase()
        HLLEventSource.shared.updateEventPool()
        
        
    }
    
    func placeholder(in context: Context) -> HLLWidgetEntry {
        HLLWidgetEntry(date: Date(), event: .previewEvent(), events: [HLLEvent](), family: context.family, state: .normal)
    }

    
    func getSnapshot(in context: Context, completion: @escaping (HLLWidgetEntry) -> ()) {
        
        if context.isPreview {
            
            let entries = getEntries(context: context, fast: true, isForTimeline: false, isForPreview: true)
            
            if entries.first?.event != nil {
                completion(entries.first!)
            } else {
                let entry = HLLWidgetEntry(date: Date(), event: .previewEvent(), events: [HLLEvent](), family: context.family, state: .normal)
                completion(entry)
                
            }
            
            
        } else {
            
            let entry = getEntries(context: context, fast: true, isForTimeline: false).first!
            completion(entry)
            
        }
        
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        ProStatusManager.shared.updateProStatus()
        HLLHiddenEventStore.shared.loadHiddenEventsFromDatabase()
        HLLEventSource.shared.updateEventPool()
        
        let entries = getEntries(context: context, fast: false, isForTimeline: true)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        print("Reloading with entries: \(timeline.entries.count)")
        completion(timeline)
        
    }
    
    
    func getEntries(context: Context, fast: Bool, isForTimeline: Bool, isForPreview: Bool = false) -> [HLLWidgetEntry] {
        
        var entries: [HLLWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.

        
        let gen = HLLTimelineGenerator(type: .widget)
        
        var state = TimelineState.normal
        
        let timeline = gen.generateHLLTimeline(fast: fast, forState: stateFetcher.getWidgetState())
        
        
        if isForPreview == false {
        
            state = timeline.state
        }
        
        if isForTimeline {
            
            difHandler.exportTimelineToDefaults(timeline: timeline, for: .widget)
            
        }
        
        let timelineItems = timeline.entries
        
        
        
        for item in timelineItems {
            
            var showEvent: HLLEvent?
            if let event = item.event {
                showEvent = event
            } else {
                showEvent = item.nextEvent
            }
            
            let entry = HLLWidgetEntry(date: item.showAt, event: showEvent, events: item.nextEvents, family: context.family, state: state)
            entries.append(entry)
        }
        
    
        
        return entries
        
        
    }
    
    
}

struct HLLWidgetEntry: TimelineEntry {
    internal init(date: Date, event: HLLEvent?, events: [HLLEvent], family: WidgetFamily, state: TimelineState) {
        self.date = date
        self.event = event
        self.events = events
        self.family = family
        self.state = state
        
        if let uEvent = event {
        
            print("Init HLLWidgetEntry with \(uEvent) at \(date.formattedDate())")
            
        } else {
            
            print("Init HLLWidgetEntry with no event at \(date.formattedDate())")
        }
        
    }
    
    
    
    
    let date: Date
    
    let state: TimelineState
    
    let event: HLLEvent?
    let events: [HLLEvent]
    let family: WidgetFamily
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
