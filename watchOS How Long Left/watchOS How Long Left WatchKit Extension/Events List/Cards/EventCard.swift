//
//  EventCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 30/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventCard: View {
    
    
     var stringGetters: [(() -> String)] {
        
         var returnArray = [(() -> String)]()
         
         let relative = { "\(event.countdownTypeString(at: self.date).capitalizingFirstLetter()) " + CountdownStringGenerator.generateCountdownTextFor(event: self.event, currentDate: self.date).justCountdown }
         let dates = { return event.getIntervalString(at: self.date) }
         
         let location = { event.location ?? relative() }
        
         
        return [location, relative, dates]
        
    }
    
    var event: HLLEvent
    
    var liveUpdates: Bool
    
    var date: Date
    
    let show = 3.5
    
    @Binding var referenceDate: Date
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            
            VStack(alignment: .leading, spacing: 1) {
                
               
                Text("\(event.title)")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(1)
                    .truncationMode(.middle)
                    .opacity(0.7)
                        
                    
                let index = Int(Date().timeIntervalSince(referenceDate) / show) % stringGetters.count
                
                Text("\(stringGetters[index]())")
                    .frame(height: 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeInOut(duration: 0.5), value: date)
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    
                    
           
                    
                
                
               
                
            }
      
        
            
        }
        
        .padding(.vertical, 3)
 
        
    }
    

}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(event: .previewEvent(), liveUpdates: true, date: Date(), referenceDate: .constant(Date()))
    }
}
