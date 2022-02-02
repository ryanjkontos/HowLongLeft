//
//  iOS_Widget_How_Logn_Left.swift
//  iOS Widget How Logn Left
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
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
        

        
        HLLEventSource.shared.updateEventPool()
        
        timeline = HLLDefaults.widget.latestTimeline ?? generator.generateHLLTimeline()
        
    }
    
    mutating func updateTimeline() {
        timeline = HLLDefaults.widget.latestTimeline ?? generator.generateHLLTimeline()
    }
    
    func placeholder(in context: Context) -> Entry {
        
        return Entry(configuration: Intent(), underlyingEntry: HLLTimelineEntry(date: Date(), event: .previewEvent()))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(configuration: configuration, underlyingEntry: timeline.entries.first!)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries = [Entry]()
        
        
        
        for entry in self.timeline.entries {
            
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
    
    var underlyingEntry: HLLTimelineEntry
    
}

struct iOS_Widget_How_Logn_LeftEntryView : View {
    
    var entry: Provider.Entry
    
    var timelineEntry: HLLTimelineEntry {
        return entry.underlyingEntry
    }

    var date: Date {
        return timelineEntry.showAt
    }
    
    
    var body: some View {
        
        if let event = timelineEntry.event {
            Text("\(event.title) \(event.countdownTypeString(at: date)) in")
            Text(event.countdownDate(at: date), style: .time)
        } else {
            Text("No Event")
        }
        
        
    }
}

@main
struct iOS_Widget_How_Logn_Left: Widget {
    let kind: String = "iOS_Widget_How_Logn_Left"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            iOS_Widget_How_Logn_LeftEntryView(entry: entry)
        }
        .configurationDisplayName("How Long Left")
        .description("Counts down Events")
    }
}

struct iOS_Widget_How_Logn_Left_Previews: PreviewProvider {
    static var previews: some View {
        iOS_Widget_How_Logn_LeftEntryView(entry: Provider.Entry(configuration: ConfigurationIntent(), underlyingEntry: .init(date: Date(), event: .previewEvent())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
