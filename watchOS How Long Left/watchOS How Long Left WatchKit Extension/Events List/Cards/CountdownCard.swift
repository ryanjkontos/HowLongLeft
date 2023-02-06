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

    var date: Date
    
    var stringGetters: [(() -> String)] {
       
        var array = [(() -> String)]()
        

        let dates = {
            return "Ends: \(event.endDate.formattedTime())" }
        array.append(dates)
        
        
        
       return array
       
   }
    
    let show = 2.5
    
    @Binding var referenceDate: Date
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3) {
            
            VStack(alignment: .leading, spacing: 1) {
  
                
                
                HStack(spacing: 2) {

                    
                    HStack(alignment: .bottom, spacing:0 ) {
                        Text("\(event.title)")
                            .truncationMode(.middle)
                            .layoutPriority(0)
                        Text(" \(event.countdownTypeString)")
                    }
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .lineLimit(1)
                .foregroundColor(.primary)
                .opacity(0.7)
                }
                    
                   
                
               Text(getTimerText())
                    .monospacedDigit()
                    .foregroundColor(.primary)
                    .font(.system(size: 19, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .opacity(0.7)
                    
                
            }
            
            
            let index = Int(Date().timeIntervalSince(referenceDate) / show) % stringGetters.count
            Text("\(stringGetters[index]())")
                .animation(.easeInOut)
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .lineLimit(1)
                    //.minimumScaleFactor(0.5)
            
            
     
            
            
        }
        .listRowBackground(ZStack{ GeometryReader { proxy in
            
            Color.green.opacity(0.18)
            Color.green.opacity(0.20)
                .frame(width: proxy.size.width/100)
            
            
            
        }
            
           
                
            
        }.cornerRadius(10))
        .padding(.vertical, 5)
        
       
        
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
        
        List {
            
            CountdownCard(event: .previewEvent(location: "Krispy Kreme Auburn"), date: Date(), referenceDate: .constant(Date()))
            
            CountdownCard(event: .previewEvent(location: "Krispy Kreme Auburn"), date: Date(), referenceDate: .constant(Date()))
               
               
            
        }
            
    }
}
