//
//  UpcomingEventListParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct UpcomingEventListParentView: View {
    
    @ObservedObject var eventSource = UpcomingEventSource()
    @Binding var eventViewEvent: HLLEvent?
    
    var body: some View {
        
        NavigationView {
        
        ZStack {
        
            if eventSource.isEmpty {
                VStack(spacing: 5) {
                
                Text("No Events")
                    .foregroundColor(.secondary)
                    
                   
                        
                }
            } else {
                UpcomingEventListView( eventViewEvent: $eventViewEvent)
                    .environmentObject(eventSource)
                    
            }
            
        }
        .navigationTitle("Upcoming")
        .navigationViewStyle(.stack)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.15), value: eventSource.events.isEmpty)
        
            
    }
        .navigationViewStyle(.stack)
        
    }
}

struct UpcomingEventListParentView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventListParentView(eventViewEvent: .constant(nil))
    }
}
