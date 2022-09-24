//
//  UpcomingEventListParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct UpcomingEventListParentView: View {
    
    @ObservedObject var eventSource = UpcomingEventSource()
    @Binding var eventViewEvent: HLLEvent?
    
    @State var navigationController: UINavigationController?
    
    var body: some View {
        
        NavigationView {
        
        ZStack {
        
            let _ = print(UpcomingEventListParentView._printChanges())
            
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
        .introspectNavigationController { nc in
                self.navigationController = nc
        }
            
        .onReceive(SelectedTabManager.shared.reselected, perform: { _ in
            
            self.navigationController?.popViewController(animated: true)
            
        })
            
    }
        .navigationViewStyle(.stack)
        
    }
}

struct UpcomingEventListParentView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventListParentView(eventViewEvent: .constant(nil))
    }
}
