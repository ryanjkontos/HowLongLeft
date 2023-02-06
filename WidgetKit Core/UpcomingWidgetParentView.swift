//
//  UpcomingWidgetParentView.swift
//  Mac WidgetKitExtension
//
//  Created by Ryan Kontos on 14/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI


struct UpcomingWidgetParentView: View {

    var entry: HLLWidgetTimelineEntry

    
    var body: some View {
        
        switch entry.state {
        
        case .normal:
            if entry.underlyingEntry.nextEvents.isEmpty {
                
                CountdownWidgetNoEventView().padding(.horizontal, 20)
                    
            } else {
                UpcomingListView(events: entry.underlyingEntry.nextEvents, Date: entry.date)
                    
            }
                    
        case .noCalendarAccess:
            
            WidgetDisabledView(reason: .noCalAccess)
        case .notPurchased:
            
            WidgetDisabledView(reason: .notPurchased)
        case .notMigrated:
           
           WidgetDisabledView(reason: .notMigrated)
        }
        
    }
    
}
