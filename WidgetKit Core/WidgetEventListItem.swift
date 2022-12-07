//
//  WidgetEventListItem.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 10/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

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
    

    
    var body: some View {
    
        
        HStack(alignment: .center ,spacing: 6) {
            
        Rectangle()
            .frame(width: 4.5)
            .foregroundColor(Color(event.color))
            
            VStack {
            
            Spacer()
                
                VStack(alignment: .leading, spacing: 1) {
                        
                Text("\(event.title)")
                        
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.primary)
                  
                    .layoutPriority(1)
                VStack(alignment: .leading, spacing: 0) {
                   
                    Group {
                        
                        Text("Starts: ") + Text(event.startDate, style: .relative)
                        
                    }
               // Text("\(event.startDate.userFriendlyRelativeString(at: showAt)), \(event.startDate.formattedTime())")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .layoutPriority(2)
        
                        
                }
                
                }
                
                Spacer()
                
                        
            }
            
            
            
            Spacer()
      
        }
        .colorScheme(colorScheme)
        
        .background(Color(event.color).opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 9))
            
    }
}


