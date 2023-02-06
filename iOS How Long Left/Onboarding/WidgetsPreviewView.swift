//
//  WidgetsPreviewView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 8/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI


struct WidgetsPreviewView: View {
    
    var current: PreviewEvent
    var upcomingEvents: [PreviewEvent]
    
    let multiplier = 0.0025
    
    var body: some View {
        
        GeometryReader { proxy in
        
            
            
        TabView {
                
                VStack {
               
                    CountdownWidgetEventView(event: current, displayDate: Date(), barEnabled: true)
                    .disabled(true)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 22)
                    .modifier(HLLWidgetBackground())
                    .frame(width: 175, height: 175, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
                    .shadow(color: .black.opacity(0.2), radius: 30)
                    .scaleEffect(getWidgetScale(width: proxy.size.width))
                }
                .padding(.bottom, 20)
                
            
            VStack {
           
                UpcomingListView(events: upcomingEvents, Date: Date())
                    .disabled(true)
                .padding(.vertical, 6)
                .padding(.horizontal, 22)
                .modifier(HLLWidgetBackground())
                .frame(width: 175, height: 175, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
                .shadow(color: .black.opacity(0.2), radius: 30)
                .scaleEffect(getWidgetScale(width: proxy.size.width))
            }
            .padding(.bottom, 20)
                
            GeometryReader { proxy in
            
            HStack(alignment: .center, spacing: 20) {

                CountdownWidgetEventView(event: current, displayDate: Date(), barEnabled: true)
                
                
                    UpcomingListView(events: upcomingEvents, Date: Date())
           
             
        }
            .disabled(true)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
            
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 22)
            .modifier(HLLWidgetBackground())
            .frame(width: 350, height: 175, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
            .shadow(color: .black.opacity(0.2), radius: 30)
            .scaleEffect(getWidgetScale(width: proxy.size.width))
            .padding(.bottom, 20)
     
        }
      

   

        .tabViewStyle(.page)
        
        }
            
    }
    
    func getWidgetScale(width: CGFloat) -> CGFloat {
        
        if width > 600 {
            return 1
        }
        
       return width*multiplier
        
    }
    
}

/*struct WidgetsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewView(current: , upcomingEvents: )
    }
}*/
