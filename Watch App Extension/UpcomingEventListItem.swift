//
//  UpcomingEventListItem.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 23/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct UpcomingEventListItem: View {
    
    @State var event: HLLEvent
    
    var body: some View {
    
            HStack {
                
                VStack(alignment: .leading, spacing: 1) {
                    
                    Text("\(event.title)")
                        .font(Font.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 0) {
                    
                        if let location = event.location {
                        
                    Text("\(location)")
                        .font(Font.system(size: 11, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                            
                    }
                        
                    Text("\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())")
                        .font(Font.system(size: 11, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                        
                    }
                    
                }
                
                Spacer()
                
            }
            .padding(.vertical, 5)
            
            
        
        
        
    }
}

struct UpcomingEventListItem_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventListItem(event: .previewEvent())
    }
}
