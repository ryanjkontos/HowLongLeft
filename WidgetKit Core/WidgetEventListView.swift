//
//  WidgetEventListView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 11/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetEventListView: View {
    
    let cols = GridItem(.adaptive(minimum: 150, maximum: 155))
    
    var body: some View {
        
        
        LazyVGrid(columns: [cols], spacing: 5) {
            
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            EventListItem(event: HLLEvent.previewUpcomingEvent(), showAt: Date())
            
        }
        .padding(.horizontal, 10)
        
    }
}

struct WidgetEventListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WidgetEventListView()
        }
            .previewContext(WidgetPreviewContext(family: .systemMedium))
           // .previewLayout(.fixed(width: 360, height: 169))
    }
}
