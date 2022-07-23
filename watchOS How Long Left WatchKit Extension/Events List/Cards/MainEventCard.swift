//
//  MainEventCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 30/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct MainEventCard: View {
    
    @State var event: HLLEvent
    var gen = CountdownStringGenerator()
    
    var liveUpdates: Bool
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    
    
    var date: Date
    
    var body: some View {

            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if event.isSelected {
                    
                        Text("PINNED")
                            .foregroundColor(Color("PinnedGold"))
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                        
                    }
                    
                    Text("\(event.title)")
                        .font(.system(size: 29, weight: .medium, design: .rounded))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        //.background(.blue)
                       // .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text("\(event.countdownTypeString) in")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
               
                //.frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                
                    VStack(alignment: .leading ,spacing: 0) {
                    
                Text("\(getTimerText())")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(event.color))
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                //.frame(maxWidth: .infinity, alignment: .leading)
                   
                    .multilineTextAlignment(.leading)
                
                        VStack(alignment: .leading ,spacing: 5) {
                            
                            
                            
                            if event.completionStatus(at: date) == .current {
                        
                                ProgressView(value: event.completionFraction(at: date))
                                    .tint(Color(event.color))
                                    .animation(.linear, value: event.completionFraction(at: date))
                                    .animation(.default, value: event.completionStatus(at: date))
                                    .transition(.opacity)
                                
                            }
                           
                            
                        
                       
                            if let loc = event.location, HLLDefaults.watch.largeHeaderLocation {
                            
                            VStack(alignment: .leading, spacing: 1) {
              
                                Text("\(loc)")
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    
                                    .minimumScaleFactor(0.6)
                                
                            }
                            
                        }
                            
                            
                        }
                        .padding(.vertical, 5)
                            
                        }
                
                }
                
            }
            //.padding(.bottom, 5)
        
        
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
        
        NavigationView {
        
        GeometryReader { proxy in
        
        ScrollView {
            MainEventCard(event: .previewUpcomingEvent(), liveUpdates: false, date: .init())
                .frame(height: proxy.size.height)
            
        }
            
            
        }
            
        }
        
        .previewAllWatches()
            
            
    }
}


struct PreviewAllWatches: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewDevice("Apple Watch Series 3 - 38mm")
            .previewDisplayName("38mm")
        content
            .previewDevice("Apple Watch Series 3 - 42mm")
            .previewDisplayName("42mm")
        content
            .previewDevice("Apple Watch Series 6 - 40mm")
            .previewDisplayName("40mm")
        content
            .previewDevice("Apple Watch Series 6 - 44mm")
            .previewDisplayName("44mm")
        content
            .previewDevice("Apple Watch Series 7 - 41mm")
            .previewDisplayName("41mm")
        content
            .previewDevice("Apple Watch Series 7 - 45mm")
            .previewDisplayName("45mm")
        
        
    }
}

extension View {
    func previewAllWatches() -> some View {
        modifier(PreviewAllWatches())
    }
}
