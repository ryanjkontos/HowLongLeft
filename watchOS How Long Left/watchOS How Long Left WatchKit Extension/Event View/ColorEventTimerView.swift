//
//  ColorEventTimerView.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 19/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ColorEventTimerView: View {
    
    var event: HLLEvent
    
    var body: some View {
        
        TimelineView(.periodic(from: Date(), by: .second)) { object in
            ZStack {
                ZStack {
                    
                    GeometryReader { proxy in
                        
                        Color(event.color)
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        Color(event.color)
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: proxy.size.width * PercentageCalculator.completionValue(for: event, at: object.date))
                        
                    }
                    
                }
                
                VStack {
                    
                    VStack(spacing: 6) {
                        VStack(spacing: 2) {
                            
                            Text("\(event.title)")
                                .font(.system(size: 18, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            VStack {
                            
                                if event.completionStatus(at: object.date) == .upcoming {
                                    Text("starts in")
                                        .font(.system(size: 13, weight: .regular, design: .default))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                
                            Text(getTimerText(at: object.date))
                                .font(.system(size: 35, weight: .regular, design: .default))
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                
                            }
                            
                           
                            
                        }
                        
                        if event.completionStatus(at: object.date) == .current {
                        
                            Text("\(PercentageCalculator.calculatePercentageDone(for: event, at: object.date))")
                                .monospacedDigit()
                            .foregroundColor(.secondary)
                            //.minimumScaleFactor(0.5)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        
    }
    
    func getTimerText(at date: Date) -> String {
        
        if event.completionStatus(at: date) == .done {
            return "Done"
        }
        
        var showSeconds = true
        
        if HLLDefaults.watch.showSeconds == false {
            showSeconds = false
        }

        
        return CountdownStringGenerator.generatePositionalCountdown(event: event, at: date, showSeconds: showSeconds)
        
    }
    
}

struct ColorEventTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorEventTimerView(event: .previewEvent())
            .previewAllWatches()
    }
}
