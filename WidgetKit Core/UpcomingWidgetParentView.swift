//
//  UpcomingWidgetParentView.swift
//  Mac WidgetKitExtension
//
//  Created by Ryan Kontos on 14/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI


struct UpcomingWidgetParentView: View {

    var entry: HLLWidgetEntry

    
    var body: some View {
        
    
        getView()
    }
    
    func getView() -> AnyView {
        
        switch entry.state {
        
        case .normal:
            if entry.events.isEmpty {
                return AnyView(CountdownWidgetNoEventView().padding(.horizontal, 20))
                    
            } else {
                return AnyView(UpcomingListView(events: entry.events, showAt: entry.date).padding(.horizontal, 10))
                    
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
