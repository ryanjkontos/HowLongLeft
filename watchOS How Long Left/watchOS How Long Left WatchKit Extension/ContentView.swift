//
//  ContentView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import ClockKit

struct ContentView: View {
    
    @ObservedObject var store = Store()
    
    var body: some View {

            
            if HLLEventSource.shared.access == .Denied {
                NoCalendarAccessView()
            } else {
                EventsListView()
                    .environmentObject(store)
                    
            }
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
