//
//  Complication_Widget_Extension.swift
//  Complication Widget Extension
//
//  Created by Ryan Kontos on 3/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import WidgetKit
import SwiftUI


struct ComplicationWidgetTimelineProvider: TimelineProvider {
    
    let timelineGen = HLLTimelineGenerator(type: .complication)
    
    init() {
        
       // CXLogger.log("Initting CWTP")
        
        HLLEventSource.shared = HLLEventSource()
        HLLDataModel.shared = HLLDataModel()
        HLLEventSource.shared.updateEvents()
    
      
        
       // EventLocationStore.shared = EventLocationStore()
    }
    

    func placeholder(in context: Context) -> HLLTimelineEntry {
        
        HLLTimelineEntry(date: Date(), event: .previewUpcomingEvent())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HLLTimelineEntry) -> ()) {
        
        DispatchQueue.main.async {
            
          //  CXLogger.log("Get snapshot")

               // let timeline = timelineGen.generateHLLTimeline()
                let entry = HLLTimelineEntry(date: Date(), event: .previewEvent(title: "Lolz", status: .current, location: nil))
                completion(entry)
            
            
        }
        
       
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        DispatchQueue.main.async {
            
            
            
          //  CXLogger.log("Get timeline")
     
            HLLEventSource.shared.addClosure {
                //CXLogger.log("Closure called for get timelien")
         
            }
            
                // let timeline = timelineGen.generateHLLTimeline()
                
                let timeline = Timeline(entries: [HLLTimelineEntry(date: Date(), event: .previewEvent(title: "Lolz", status: .current, location: nil))], policy: .atEnd)
                completion(timeline)
            
            
        }
        
        
    }
}




@main
struct Complication_Widget_Extension: Widget {
    let kind: String = "Complication_Widget_Extension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplicationWidgetTimelineProvider()) { entry in
            AccessoryRectangularComplicationView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}


