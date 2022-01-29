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
            
            
            Text("\(event.title) \(event.countdownTypeString) in")
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text("\(getTimerText())")
                .monospacedDigit()
                .foregroundColor(Color(event.color))
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
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
