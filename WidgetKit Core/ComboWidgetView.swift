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
    
    var entry: HLLWidgetEntry
    
    
    var body: some View {
        
        getView()
        
    }
    
    func getView() -> AnyView {
        
        switch entry.state {
        
        case .normal:
            
            return AnyView(GeometryReader { proxy in
                
                HStack(alignment: .center, spacing: 20) {

                    CountdownWidgetParentView(entry: entry)
                    //.frame(width: proxy.size.width/2)
                    //.background(Color.green)
                        
                    if !(entry.events.isEmpty && entry.event == nil) {
                    
                        UpcomingListView(events: entry.events, showAt: entry.date)
                   // .frame(width: proxy.size.width/2)
                    //.background(Color.blue)
                    
                        
                    }
            }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            
                
            }
            .padding(.horizontal, 20))
            
        case .noCalendarAccess:
            return AnyView(WidgetDisabledView(reason: .noCalAccess))
        case .notPurchased:
            return AnyView(WidgetDisabledView(reason: .notPurchased))
        case .notMigrated:
            return AnyView(WidgetDisabledView(reason: .notMigrated))
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
