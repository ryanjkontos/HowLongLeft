//
//  EventTimerView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 2/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventTimerView: View {
    
    var event: HLLEvent
    

    
    let date = Date()
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        if scenePhase == .active {
            
            
            TimelineView(.animation) { context in
                getContent(timelineDate: context.date)
                    
            }
        } else {
            TimelineView(.periodic(from: Date(), by: 1)) { context in
                getContent(timelineDate: context.date)
                    
            }
        }

    }
    
    func getContent(timelineDate: Date) -> some View {
        
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .stroke(lineWidth: isLuminanceReduced ? 5 : 6)
                        .foregroundColor(.gray.opacity(0.25))
                    
                    Circle()
                        .trim(from: 0, to: PercentageCalculator.completionValue(for: event, at: timelineDate))
                        .stroke(style: StrokeStyle(lineWidth: isLuminanceReduced ? 5 : 6, lineCap: .round))
                        
                        .shadow(radius: 2)
                        .rotationEffect(.degrees(-90))
                       // .opacity(getHideRingState(at: timelineDate) ? 0.0 : 1.0)
                        .foregroundColor(Color(event.color))
                       // .animation(.default, value: getHideRingState(at: timelineDate))
                }
                    .overlay {
                        
                        VStack(spacing: 6) {
                            VStack(spacing: 2) {
                                
                                Text("\(event.title)")
                                    .font(.system(size: 18, weight: .regular, design: .default))
                                    .foregroundColor(.secondary)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                                
                                VStack {
                                
                                    if event.completionStatus(at: timelineDate) == .upcoming {
                                        Text("starts in")
                                            .font(.system(size: 13, weight: .regular, design: .default))
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                Text(getTimerText(at: timelineDate))
                                    .font(.system(size: 35, weight: .regular, design: .default))
                                    .monospacedDigit()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.4)
                                    
                                }
                                
                               
                                
                            }
                            
                            if event.completionStatus(at: timelineDate) == .current {
                            
                                Text("\(PercentageCalculator.calculatePercentageDone(for: event, at: timelineDate))")
                                    .monospacedDigit()
                                .foregroundColor(.secondary)
                                //.minimumScaleFactor(0.5)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                
                            }
                            
                        }
                        .padding(.all, 30)
                        .animation(.easeInOut, value: isLuminanceReduced)
                        
                    }
                    
                    .frame(width: geometry.size.width, height: geometry.size.width-25)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            
            }
            
            
    }
    
    func getHideRingState(at date: Date) -> Bool {
        
        return isLuminanceReduced && event.completionStatus(at: date) != .done
        
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

struct EventTimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventTimerView(event: .previewEvent())
        }
        
    }
}
