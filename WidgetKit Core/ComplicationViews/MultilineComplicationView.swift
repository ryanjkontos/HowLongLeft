//
//  MultilineComplicationView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 12/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MultilineComplicationView: View {
    
    @Environment(\.widgetFamily) private var family
    var event: HLLEvent?
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
         
                HStack {
                    
                    
                    
                    Text("\(event?.title ?? "No Event")")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    
                }
          

                    Text("ends in ") +
                    Text(Date().addingTimeInterval(1000), style: .timer)
                    
                
                
                Gauge(value: 0.5, label: {
                    
                })
                
                
                .gaugeStyle(.accessoryLinearCapacity)
                .tint(.orange)
            }
            Spacer()
        }
        
    }
}

struct MultilineComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultilineComplicationView(event: .previewEvent())
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        }
    }
}
