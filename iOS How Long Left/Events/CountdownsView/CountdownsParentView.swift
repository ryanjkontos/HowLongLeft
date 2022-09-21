//
//  InProgressParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct CountdownsParentView: View {
    
    @ObservedObject var eventSource = EventSource()
    @Binding var eventViewEvent: HLLEvent?
    
    @State var showSettings = false
    
    @Binding var launchEvent: HLLEvent?
    
    @State var navigationController: UINavigationController?
    
    var body: some View {
        
        NavigationView {
        
        Group {
        
            if eventSource.isEmpty {
                VStack(spacing: 5) {
                
                Text("No Countdowns")
                   .foregroundColor(.secondary)
                    
                }
            } else {
                CountdownsView(eventViewEvent: $eventViewEvent, launchEvent: $launchEvent)
                    .environmentObject(eventSource)
                
            }
            
        }
    
        .navigationViewStyle(.stack)
       
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.15), value: eventSource.isEmpty)
        
        .navigationBarTitleDisplayMode(.large)
            
        .navigationTitle("Countdowns")
            
        .introspectNavigationController { nc in
                self.navigationController = nc
        }
            
        .onReceive(SelectedTabManager.shared.reselected, perform: { _ in
            
            self.navigationController?.popViewController(animated: true)
            
            let body = self.body
            
         
            
        })
            
        }
      
        .navigationViewStyle(.stack)
        
    }
}

struct InProgressParentView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsParentView(eventViewEvent: .constant(nil), launchEvent: .constant(nil))
    }
}
