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
    
    let entry: HLLWidgetEntry
    

    var body: some View {
        
       getView()
        
    }
    
    func getView() -> AnyView {
        
        switch entry.state {
        
        case .normal:
            
            if let unwrappedEvent = entry.event {
                return AnyView(CountdownWidgetEventView(event: unwrappedEvent, displayDate: entry.date))
                    
            } else {
                return AnyView(CountdownWidgetNoEventView())
                
            }
            
        case .noCalendarAccess:
            return AnyView(WidgetDisabledView(reason: .noCalAccess))
        case .notPurchased:
            return AnyView(WidgetDisabledView(reason: .notPurchased))
        case .notMigrated:
            return AnyView(WidgetDisabledView(reason: .notMigrated))
        }
        
    }
}

