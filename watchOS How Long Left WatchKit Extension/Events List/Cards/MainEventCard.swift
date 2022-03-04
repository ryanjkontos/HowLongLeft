//
//  MainEventCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 30/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct MainEventCard: View {
    
    var event: HLLEvent
    var gen = CountdownStringGenerator()
    
    var liveUpdates: Bool
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    
                    if event.isSelected {
                    
                        Text("PINNED")
                            .foregroundColor(Color("PinnedGold"))
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                    }
                    
                    Text("\(event.title)")
                        .font(.system(size: .watchDynamic(size38mm: 29, size40mm: 30, size41mm: 29, size42mm: 35, size44mm: 33, size45mm: 33), weight: .medium, design: .rounded))
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    Text("\(event.countdownTypeString) in")
                        .foregroundColor(.secondary)
                        .font(.system(size: 19, weight: .regular, design: .rounded))
                }
               
                
                VStack(alignment: .leading, spacing: 2) {
                
                    VStack(spacing: 3) {
                    
                Text("\(getTimerText())")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(event.color))
                    .font(.system(size: .watchDynamic(size38mm: 29, size40mm: 31, size41mm: 32, size42mm: 33, size44mm: 35, size45mm: 37), weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .leading)
                   
                    .multilineTextAlignment(.leading)
                
                        if event.completionStatus(at: date) == .current {
                    
                            ProgressView(value: event.completionFraction(at: date))
                                .tint(Color(event.color))
                                .animation(.linear, value: event.completionFraction(at: date))
                                .animation(.default, value: event.completionStatus(at: date))
                                .transition(.opacity)
                            
                        }
                        
                    }
               
                    
                    if let location = event.location {
                        
                        VStack(alignment: .center) {
                           
                            Divider()
                            
                            Text(location)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                
                                .minimumScaleFactor(0.6)
                            
                            Divider()
                            
                        }
                      //  .padding(.top, 7)
                        
                    }
                
                }
                
            }
            Spacer()
        }
        
    }
    
    func getTimerText() -> String {
        
        var showSeconds = liveUpdates
        
        if HLLDefaults.watch.showSeconds == false {
            showSeconds = false
        }

        
        return gen.generatePositionalCountdown(event: event, at: date, showSeconds: showSeconds)
    }
    
}

struct MainEventCard_Previews: PreviewProvider {
    static var previews: some View {
        MainEventCard(event: .previewEvent(), liveUpdates: false, date: .init())
    }
}
