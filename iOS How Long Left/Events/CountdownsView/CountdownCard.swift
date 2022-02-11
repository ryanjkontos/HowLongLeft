//
//  CountdownCard.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 5/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownCard: View {
    
    static var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var event: HLLEvent
    
    @State var timerText: String = ""
    @State var statusText: String = ""
    
    @State var visible = false
    
    @State var style = HLLDefaults.countdownsTab.cardAppearance
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
        
            Color(uiColor: .systemBackground)
            Color(uiColor: event.color)
                .opacity(0.6)
            
   
            HStack(spacing: 15) {
                
               
                
                VStack(alignment: .leading, spacing: 11) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                    
                        Text(event.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.trailing, 13)
                        .foregroundColor(getTextColor())
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .opacity(0.9)
                     //   .shadow(radius: 6)
                        
                        Text(statusText)
                        
                            .foregroundColor(.secondary)
                        .font(.system(size: 19, weight: .regular, design: .default))
                        .opacity(1)
                       // .shadow(radius: 6)
                    
                    }
                  
            
                }
                
               
                Spacer()
                
                Text(timerText)
                    .foregroundColor(.primary)
                    .font(.system(size: 28, weight: .medium, design: .default))
                        .opacity(0.8)
                        .monospacedDigit()
                        
                        //.shadow(radius: 6)
             
                
            }
            .padding(.vertical, 0)
            .padding(.leading, 19)
            .padding(.trailing, 22)
                
            
            
        }
        .frame(height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
         
         
        .drawingGroup()
        .onAppear(perform: {
            
            style = HLLDefaults.countdownsTab.cardAppearance
            
            visible = true })
        .onDisappear(perform: { visible = false })
        .onReceive(CountdownCard.timer, perform: { _ in
            
            if !visible {
                return
            }
            
            let date = Date()
            timerText = getCountdown(date: date)
            statusText = getStatusText(date: date)
            
        })
            
            
             
        
    }
        
        

    
    func getTextColor() -> Color {
        
        .primary.opacity(0.93)
        
    }
        
    
    func getCountdown(date: Date) -> String {
        
        CountdownStringGenerator.shared.generatePositionalCountdown(event: event, at: date, showSeconds: HLLDefaults.countdownsTab.showSeconds)
        
    }
    
    func getStatusText(date: Date) -> String {
        
        switch event.completionStatus(at: date) {
            
        case .upcoming:
            return "starts in"
        case .current:
            return "ends in"
        case .done:
            return "is"
        }
        
    }
}

struct NewCountdownCard_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCard(event: .previewEvent())
    }
}
