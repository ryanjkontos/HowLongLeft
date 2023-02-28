//
//  AccessoryRectangularComplicationView.swift
//  watchOS How Long Left
//
//  Created by Ryan Kontos on 3/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI
import ClockKit

@available(iOS 16.0, *)
struct AccessoryRectangularComplicationView: View {
    
    var entry: HLLTimelineEntry
    
    var body: some View {
        
        if let event = entry.event {
        
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(event.title)
                        .widgetAccentable()
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    //.font(.system(size: 21))
                    Text("\(event.countdownTypeString(at: entry.date)) ") + Text(event.countdownDate(at: entry.date), style: .timer)
                    //.font(.system(size: 19))
                }
                
                generateThirdRowView()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                
            } else {
                Text("No Events")
            }
        
    }
    
    func generateThirdRowView() -> AnyView {
        
        guard let event = entry.event else { return AnyView(EmptyView()) }
        
        let isInStartPeriod = entry.date.timeIntervalSince(event.startDate) < (5*60)
        
        var thirdRowMode = HLLDefaults.complication.mainThirdRowMode
    
        if isInStartPeriod, let startThirdRowMode = HLLDefaults.complication.alternateThirdRowMode {
            thirdRowMode = startThirdRowMode
        } else if HLLDefaults.complication.progressBar && event.completionStatus(at: entry.date) == .current {
            
            return AnyView(Gauge(value: 0.2, label: {
               EmptyView()
                
            })
                .gaugeStyle(.accessoryLinearCapacity)
                .padding(.top, 7)
                .tint(.blue)
                .widgetAccentable())
            
        }
        
        var text: String
        
        switch thirdRowMode {
            
        case .nextEvent:
            
            if let next = entry.nextEvent {
                text = "Next: \(next.title)"
            } else {
                text = "Nothing Next"
            }
            
            
        case .location:
            text = "\(event.location ?? "No Location")"
        case .time:
            text = event.countdownDate(at: entry.date).formattedTime()
        }
        
        
        return AnyView(Text(text)
            .opacity(0.8))
           // .font(.system(size: 15))
            //.padding(.top, 5))
        
        
    }
    
}

/*struct AccessoryRectangularComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        
      //  CLKComplicationTemplateGraphicRectangularFullView(AccessoryRectangularComplicationView(entry: .init(date: Date(), event: .previewEvent(title: "Current", status: .upcoming, location: nil)))).previewContext()
        
        
            
    }
}

*/
