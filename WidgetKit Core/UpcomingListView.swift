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
    var showAt: Date
  
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
            
            
            return Array(events.filter({ $0.completionStatus(at: showAt) == .upcoming }).prefix(3))
            
        }
        
    }
    
    var body: some View {
        
        if !limitedEvents.isEmpty {
        
            HStack {
            
            VStack(alignment: .leading) {
                
                if limitedEvents.count == 3 {
                
                Spacer()
                    
                }
            
                VStack(spacing: 6) {
            
                    
                    
                    ForEach(limitedEvents, id: \.id) { value in
                EventListItem(event: value, showAt: showAt)
                
          
                    
            }
                 
          
                }
                
                
                Spacer()
                    
                
            
        }
                
             
            }
            .colorScheme(colorScheme)
            .padding(.vertical, 20)
        
        } else {
            
            EmptyView()
            
        }
        
        
                    
    }
}




struct EventListItem: View {
    
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
    
    var event: EventUIObject
    var showAt: Date
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    

    
    var body: some View {
    
        
        HStack(alignment: .center ,spacing: 6) {
            
        Rectangle()
            .frame(width: 4.5)
            .foregroundColor(Color(event.color))
            
            VStack {
            
            Spacer()
                
                VStack(alignment: .leading, spacing: 0.2) {
                        
                Text("\(event.title)")
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium))
                    //.foregroundColor(Color(.textColor))
                  
                VStack(alignment: .leading, spacing: 0) {
                    
                Text("\(event.startDate.userFriendlyRelativeString(at: showAt)), \(event.startDate.formattedTime())")
                    .font(.system(size: 11.2, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
        
                        
                }
                
                }
                
                Spacer()
                
                        
            }
            
            
            
            Spacer()
      
        }
        .colorScheme(colorScheme)
        .frame(height: 40)
        .background(Color(event.color).opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 6))
            
    }
}
