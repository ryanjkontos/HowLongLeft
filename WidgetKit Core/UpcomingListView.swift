//
//  UpcomingListView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit
import os


struct UpcomingListView: View {
    
    var events: [EventUIObject]
    var Date: Date

    var isPreview = false
    
    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    
    var colorScheme: ColorScheme {
        
        if HLLDefaults.widget.theme == .system {
            return systemColorScheme
        }
        
        if HLLDefaults.widget.theme == .dark {
            return .dark
        }
        
        return .light
    }
    
    var limitedEvents: [EventUIObject] {
        
        get {
            
            
            return Array(events.filter({ $0.completionStatus(at: Date) == .upcoming }).prefix(3))
            
        }
        
    }
    
    var body: some View {
        
        if !limitedEvents.isEmpty {
        
            HStack {
            
            VStack(alignment: .leading) {
                
                if limitedEvents.count == 3 {
                
                Spacer()
                    
                }
            
                VStack(spacing: 4) {
            
                    
                    ForEach(limitedEvents, id: \.id) { value in
                       
                       Link(destination: URL(string: "howlongleft://event/\(value.id)")!) {
                            EventListItem(event: value, Date: Date)
                                .frame(height: 44)
                                
                        }
                        .disabled(isPreview)
                        
                        
                
          
                    
            }
                 
          
                }
                
                
                Spacer()
                    
                
            
        }
                
             
            }
            .colorScheme(colorScheme)
           
            .padding(.horizontal, 7)
        
        } else {
            
            EmptyView()
            
        }
        
        
                    
    }
}




struct UpcomingListView_Previews: PreviewProvider {
    
    static var upcomingEvents = [PreviewEvent.upcomingPreviewEvent(minsStartingIn: 60, color: .systemCyan), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 120, color: .systemGreen), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 180, color: .systemOrange)]
    
    var current = PreviewEvent.inProgressPreviewEvent(color: .systemCyan)
    
    static var previews: some View {
        UpcomingListView(events: upcomingEvents, Date: Date(), isPreview: false)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .modifier(HLLWidgetBackground())
            
    }
}
