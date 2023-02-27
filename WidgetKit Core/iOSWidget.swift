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
//import ActivityKit


struct Provider: IntentTimelineProvider {
    
    #if os(watchOS)
    
   /* func recommendations() -> [IntentRecommendation<HLLWidgetConfigurationIntent>] {
        return [IntentRecommendation(intent: HLLWidgetConfigurationIntent.init(), description: "Default Configuration")]
    } */
    
    
    #endif
    
    
    
    typealias Entry = HLLWidgetTimelineEntry
    

    typealias Intent = HLLWidgetConfigurationIntent
  
    
    
    let configStore = WidgetConfigurationStore()
    var generator: HLLTimelineGenerator

    let storageManager = WidgetHLLTimelineStorageManager()
    
    init() {
        
        HLLDataModel.shared = HLLDataModel()
        
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }
        
        #if os(watchOS)
            generator = HLLTimelineGenerator(type: .complication)
        #else
            generator = HLLTimelineGenerator(type: .widget)
        #endif
        
        
        while CalendarReader.shared.calendarAccess != .Granted { print("Waiting for access ") }
        
        #if os(iOS)
        
        WidgetUpdateHandler.shared = WidgetUpdateHandler()
        //ProStatusManager.shared = ProStatusManager()
        
        #endif
        
        HLLStoredEventManager.shared.loadStoredEventsFromDatabase()
        HLLEventSource.shared.updateEvents()
        
    
        
        
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
        
        
        HLLEventSource.shared.updateEvents()
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
        HLLEventSource.shared.updateEvents()
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
        return underlyingEntry.date
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
       
      
       // CountdownComplication()

    #if !targetEnvironment(macCatalyst)
       if #available(iOS 16.1, *) {
           LiveEventActivityWidget()
       }
       #endif
       
   }
    
    
    
}



/*@available(iOSApplicationExtension 16.0, *)
struct CountdownComplication: Widget {
    
   
    
    let kind: String = "CountdownComplication"
    
    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider(), content: { entry in
            
            MultilineComplicationView(event: entry.underlyingEntry.event, date: entry.date)
            
        })
        .description("Shows a countdown for a current or upcoming event.")
        .configurationDisplayName("Countdown")
        .supportedFamilies([.accessoryRectangular])
        
    }

} */



struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: Provider.Intent.self, provider: Provider()) { entry in
            
          //  CountdownsListWidget()
            
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
            
            WidgetEventListView()
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

#if !targetEnvironment(macCatalyst)

@available(iOSApplicationExtension 16.1, *)
struct LiveEventActivityWidget: Widget {
    
    
    var body: some WidgetConfiguration {
        
        
        
        ActivityConfiguration(for: LiveEventAttributes.self) { context in
            
            CountdownWidgetEventView(event: context.attributes.event, displayDate: Date(), barEnabled: false)
                .padding(.horizontal, 20)
                .activityBackgroundTint(Color(UIColor.systemBackground))
            
        } dynamicIsland: { context in
            
            
            
            DynamicIsland(expanded: {
               
                DynamicIslandExpandedRegion(.leading) {
                    
                    CountdownWidgetEventView(event: context.attributes.event, displayDate: Date(), barEnabled: false)
                        .padding(.horizontal, 20)
                        .activityBackgroundTint(Color(#colorLiteral(red: 0.07201712472, green: 0.07201712472, blue: 0.07201712472, alpha: 1)))
                    
                    
                }
                
                
            }, compactLeading: {
                
                Text(context.attributes.event.title)
                   // .foregroundColor(Color(context.state.event.color))
                    .minimumScaleFactor(0.5)
                    
                
            }, compactTrailing: {
                
                HStack(alignment: .center) {
                    
                 
                    
                    let event = context.attributes.event
                    
                    let range = Date()...event.countdownDate
                    
                    if event.completionStatus == .upcoming {
                        (Text("in ") + Text(timerInterval: range, pauseTime: range.lowerBound))
                   
                            .foregroundColor(Color(context.attributes.event.color))
                            .minimumScaleFactor(0.5)
                            .fontWeight(.bold)
                    } else {
                        Text(timerInterval: range, pauseTime: range.lowerBound)
                            
                            .foregroundColor(Color(context.attributes.event.color))
                            .minimumScaleFactor(0.5)
                            .fontWeight(.bold)
                    }
                    
                   
                    
                    Spacer()
                    
                  
                    
                    
                }
                
               
                
            }, minimal: {
                
                Circle()
                    .foregroundColor(.yellow)
                
            })
        }
        
      
    }
}

/*struct iOSWidget_Previews: PreviewProvider {
    static var previews: some View {
        iOSWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
*/



#endif
