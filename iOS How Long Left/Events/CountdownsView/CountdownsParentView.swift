//
//  InProgressParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownsParentView: View {
    
    @ObservedObject var eventSource = EventSource()
    @Binding var eventViewEvent: HLLEvent?
    
    @State var showSettings = false
    
    var body: some View {
        
        NavigationView {
        
        ZStack {
        
            if eventSource.isEmpty {
                VStack(spacing: 5) {
                
                Text("No Countdowns")
                    .foregroundColor(.secondary)
                    
                }
            } else {
                CountdownsView(sections: $eventSource.eventSections, eventViewEvent: $eventViewEvent)
                    .environmentObject(eventSource)
            }
            
        }
        .navigationViewStyle(.stack)
        .navigationTitle("Countdowns")
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.15), value: eventSource.isEmpty)




        }
        .navigationViewStyle(.stack)
        
    }
}

struct InProgressParentView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsParentView(eventViewEvent: .constant(nil))
    }
}
