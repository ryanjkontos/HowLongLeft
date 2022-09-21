//
//  CountdownCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownCard: View {
    
    var event: HLLEvent
    var gen = CountdownStringGenerator()
    
    var liveUpdates: Bool
    
    var date: Date
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 1) {
            
            VStack(alignment: .leading, spacing: 0) {
  

                    Text("\(event.title) \(event.countdownTypeString)")
                        .layoutPriority(0)
              
                .truncationMode(.head)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .lineLimit(1)
                .foregroundColor(.primary)
                    
                   
                
                Text("\(getTimerText())")
                    .monospacedDigit()
                    .foregroundColor(.primary)
                    .font(.system(size: 21, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .opacity(0.9)
                    
                
            }
            
            if let loc = event.location, HLLDefaults.watch.largeHeaderLocation {
                Text(loc)
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .lineLimit(1)
                    //.minimumScaleFactor(0.5)
            }
            
        }
        .padding(.vertical, 6)
        
    }
    
    func getTimerText() -> String {
        
        var showSeconds = liveUpdates
        
        if HLLDefaults.watch.showSeconds == false {
            showSeconds = false
        }
        
        return gen.generatePositionalCountdown(event: event, at: date, showSeconds: showSeconds)
    }
    
}

struct CountdownCard_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCard(event: .previewEvent(), liveUpdates: true, date: Date())
    }
}
