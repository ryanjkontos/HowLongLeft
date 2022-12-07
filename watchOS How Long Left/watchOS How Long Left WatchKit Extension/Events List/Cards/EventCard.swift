//
//  EventCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 30/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventCard: View {
    
    var event: HLLEvent
    
    var liveUpdates: Bool
    
    var date: Date
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            
            VStack(alignment: .leading, spacing: 1) {
                
                Text(getDateString())
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                HStack(spacing: 2) {
 
                        
                        Text("\(event.title)")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .lineLimit(2)
                            .minimumScaleFactor(1)
                            .truncationMode(.middle)
                        
                    
                    
                }
                
               
                
            }
            
                
                if let loc = event.location, HLLDefaults.watch.largeHeaderLocation {
                    Text(loc)
                        .foregroundColor(.secondary)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .lineLimit(1)
                    
                }
        
            
        }
        
        .padding(.vertical, 8)
        
    }
    
    func getDateString() -> String {
        
       
            return "\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())"
        
        
      //  return event.startDate.userFriendlyRelativeString(at: date)
        
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(event: .previewEvent(), liveUpdates: true, date: Date())
    }
}
