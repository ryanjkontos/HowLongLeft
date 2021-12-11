//
//  CurrentEventListItem.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 23/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CurrentEventListItem: View {
    
    @State var event: HLLEvent
    
    var body: some View {
            
            VStack(alignment: .leading, spacing: 8) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                    
                    Text("\(event.title) \(event.countdownTypeString) in")
                        .font(Font.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(Color.primary)
                        .padding(.vertical, -4)
                    Countdown(event: event)
                        .font(Font.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.blue)
                        
                    }
                    
                    Capsule()
                        .frame(height: 3.5)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .overlay(
                        
                            GeometryReader { proxy in
                            
                            Capsule()
                                .foregroundColor(Color.blue)
                                .frame(width: proxy.size.width/2)
                                .shadow(radius: 3)
                                
                            }
                        
                        )
                    
                    
                }
              
            
            .padding(.vertical, 10)
            
            
        
    }
}

struct EventListItem_Previews: PreviewProvider {
    static var previews: some View {
        CurrentEventListItem(event: .previewEvent())
    }
}
