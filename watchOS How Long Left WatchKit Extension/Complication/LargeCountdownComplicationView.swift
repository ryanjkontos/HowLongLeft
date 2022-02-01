//
//  LargeCountdownComplicationView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 26/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import ClockKit

struct LargeCountdownComplicationView: View {
    
    
    var date: Date?
    var text = ""
    
    var style: Text.DateStyle = .offset
    
    init(provider: CLKTextProvider) {
        
        if let timerProvider = provider as? CLKRelativeDateTextProvider {
            date = timerProvider.date
            
            if timerProvider.relativeDateStyle == .timer {
                style = .timer
            }
            
        }
        
        if let textProvider = provider as? CLKSimpleTextProvider {
            text = textProvider.text
        }
        
    }
    
    var body: some View {
        
        HStack {
          
            Group {
        
                if let date = date {
                    Text(date, style: .timer)
                       
                } else {
                    Text(text)
                }
                
            }
            .monospacedDigit()
            .font(.system(size: 47, weight: .regular, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Spacer()
            
        }
        .padding(.bottom, 10)
    }
}

struct LargeCountdownComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        LargeCountdownComplicationView(provider: CLKSimpleTextProvider(text: "Text"))
    }
}
