//
//  CountdownCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Marquee

struct CountdownCard: View {
    
    var event: HLLEvent

    var date: Date
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            
            VStack(alignment: .leading, spacing: 0) {
  
                
                
                HStack(spacing: 2) {

                    
                    HStack(alignment: .bottom, spacing:0 ) {
                        Text("\(event.title)")
                            .truncationMode(.middle)
                            .layoutPriority(0)
                        Text(" \(event.countdownTypeString)")
                    }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .lineLimit(1)
                .foregroundColor(.primary)
                }
                    
                   
                
                Text("\(getTimerText())")
                    .monospacedDigit()
                    .foregroundColor(.primary)
                    .font(.system(size: 23, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .opacity(0.9)
                    
                
            }
            
            if let info = WatchInfoLabelGenerator.getLabelFor(event: event, at: date) {
                Text(info)
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .lineLimit(1)
                    //.minimumScaleFactor(0.5)
            }
            
        }
        .padding(.vertical, 7)
        
    }
    
    func getTimerText() -> String {
        
        var showSeconds = true
        
        if HLLDefaults.watch.showSeconds == false {
            showSeconds = false
        }
        
        return CountdownStringGenerator.generatePositionalCountdown(event: event, at: date, showSeconds: showSeconds)
    }
    
}

struct CountdownCard_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCard(event: .previewEvent(location: "Krispy Kreme Auburn"), date: Date())
            
    }
}
