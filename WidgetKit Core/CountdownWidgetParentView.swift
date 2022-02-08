//
//  CountdownWidgetParentView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI


@available(OSX 10.15, *)
struct CountdownWidgetParentView : View {
    
    let entry: HLLWidgetTimelineEntry
    
    var body: some View {
        
        switch entry.state {
        
        case .normal:
            
            if let unwrappedEvent = entry.underlyingEntry.event {
                 CountdownWidgetEventView(event: unwrappedEvent, displayDate: entry.date)
            } else {
                 CountdownWidgetNoEventView()
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

