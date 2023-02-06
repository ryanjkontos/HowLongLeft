//
//  AccessoryRectangularComplicationView.swift
//  watchOS How Long Left
//
//  Created by Ryan Kontos on 3/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI
import ClockKit

struct AccessoryRectangularComplicationView: View {
    
    var entry: HLLTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(entry.event?.title ?? "No Events")
                    .widgetAccentable()
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    //.font(.system(size: 21))
                Text("ends: ") + Text(entry.date, style: .timer)
                    //.font(.system(size: 19))
            }
            
            generateThirdRowView()
                
            
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    func generateThirdRowView() -> AnyView {
        
        guard let event = entry.event else { return AnyView(EmptyView()) }
        
        let isInStartPeriod = entry.date.timeIntervalSince(event.startDate) < (5*60)
        
        var thirdRowMode = HLLDefaults.complication.mainThirdRowMode
    
        if isInStartPeriod, let startThirdRowMode = HLLDefaults.complication.alternateThirdRowMode {
            thirdRowMode = startThirdRowMode
        } else if HLLDefaults.complication.progressBar && event.completionStatus(at: entry.date) == .current {
            
            return AnyView(Gauge(value: 0.2, label: {EmptyView()})
                .gaugeStyle(.accessoryLinearCapacity)
                .padding(.top, 10)
                .tint(.blue)
                .widgetAccentable())
            
        }
        
        var text: String
        
        switch thirdRowMode {
            
        case .nextEvent:
            text = "Next: \(event.title)"
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

struct AccessoryRectangularComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        
        CLKComplicationTemplateGraphicRectangularFullView(AccessoryRectangularComplicationView(entry: .init(date: Date(), event: .previewEvent(title: "Current", status: .upcoming, location: nil)))).previewContext()
        
        
            
    }
}

