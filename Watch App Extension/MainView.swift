//
//  MainView.swift
//  WatchOS SwiftUI Extension
//
//  Created by Ryan Kontos on 28/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var bridge = EventPoolBridge()
    
    var body: some View {
        
        GeometryReader { proxy in
        
        List {
            
            if bridge.timeline.isEmpty == false {
            
            ForEach(Array(bridge.timeline.enumerated()), id: \.element) { index, event in
                
                if index == 0 {
                    
                    PrimaryEventListItem(event: event)
                        .listRowBackground(Color.clear)
                        .padding(.bottom, 20)
                        .frame(height: proxy.size.height-10)
                        .edgesIgnoringSafeArea(.horizontal)
                      
                    
                } else {
                    
                    if event.completionStatus == .Current {
                        
                        CurrentEventListItem(event: event)
                        
                    } else {
                        
                        UpcomingEventListItem(event: event)
                        
                    }
                    
                    
                }
                
            }
            
            } else {
                
                Text("No Events")
                    .padding(.vertical, 40)
                
            }
   
                    
            NavigationLink(
                destination: Text("Preferences"),
                label: {
                    HStack {
                    Spacer()
                    Text("Settings")
                        .foregroundColor(.black)
                    Spacer()
                    }
                        
                })
                .listRowPlatterColor(Color(.HLLOrange))
            
        }
            
       
        
        //.background(Color.red)
        
        
        
        
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
        
            MainView()
            .previewDisplayName("44mm")
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
            
          /*  MainView()
            .previewDisplayName("40mm")
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 40mm")) */
            
         /*   MainView()
                .previewDisplayName("38mm")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 38mm")) */
                
          /*  MainView()
                .previewDisplayName("42mm")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 42mm")) */
            
            
            
            
        }
        
    }
}
