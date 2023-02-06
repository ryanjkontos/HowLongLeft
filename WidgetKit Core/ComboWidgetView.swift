//
//  ComboWidgetView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit


struct ComboWidgetView: View {
    
    var entry: HLLWidgetTimelineEntry
    
    var body: some View {
        
        switch entry.state {
        
        case .normal:
            
            GeometryReader { proxy in
                
                HStack(alignment: .center, spacing: 20) {

                    CountdownWidgetParentView(entry: entry, progressBarEnabled: true)
                    
                    
                        UpcomingListView(events: entry.underlyingEntry.nextEvents, Date: entry.date)
               
                 
            }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
                
            
                
            }
            .padding(.horizontal, 20)
            
        case .noCalendarAccess:
           WidgetDisabledView(reason: .noCalAccess)
        case .notPurchased:
            WidgetDisabledView(reason: .notPurchased)
        case .notMigrated:
            WidgetDisabledView(reason: .notMigrated)
        }
        
    }
    


    
}

/*struct ComboWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ComboWidgetView(entry: , date: Date(), countdownEvent: .previewEvent(), events: [HLLEvent.previewEvent(), HLLEvent.previewEvent(), HLLEvent.previewEvent()])
            //.modifier(HLLWidgetBackground())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
*/
