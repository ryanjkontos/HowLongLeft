//
//  WidgetsPreviewView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 8/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI


struct WidgetsPreviewView: View {
    
    @Binding var current: PreviewEvent
    @Binding var upcomingEvents: [PreviewEvent]
    
    var body: some View {
        
        TabView {
                
                VStack {
               
                    CountdownWidgetEventView(event: current, displayDate: Date())
                    .padding(.vertical, 6)
                    .padding(.horizontal, 22)
                    .modifier(HLLWidgetBackground())
                    .frame(width: 175, height: 175, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
                    .shadow(color: .black.opacity(0.2), radius: 30)
                }
                .padding(.bottom, 20)
            
            VStack {
           
                UpcomingListView(events: upcomingEvents, showAt: Date())
                .padding(.vertical, 6)
                .padding(.horizontal, 22)
                .modifier(HLLWidgetBackground())
                .frame(width: 175, height: 175, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
                .shadow(color: .black.opacity(0.2), radius: 30)
            }
            .padding(.bottom, 20)
                
            GeometryReader { proxy in
            
            HStack(alignment: .center, spacing: 20) {

                CountdownWidgetEventView(event: current, displayDate: Date())
                
                
                    UpcomingListView(events: upcomingEvents, showAt: Date())
           
             
        }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
            
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 22)
            .modifier(HLLWidgetBackground())
            .frame(width: 350, height: 175, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .circular))
            .shadow(color: .black.opacity(0.2), radius: 30)
     
        }

   

        .tabViewStyle(.page)
        
        
    }
}

/*struct WidgetsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewView(current: , upcomingEvents: )
    }
}*/
