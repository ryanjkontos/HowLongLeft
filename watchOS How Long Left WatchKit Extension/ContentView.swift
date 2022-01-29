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
    
    var body: some View {

        
            EventsListView()
            .onAppear(perform: {
                
                if let complications = CLKComplicationServer.sharedInstance().activeComplications {
                    
                    for complication in complications {
                        CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
                    }
                    
                }
                
                
            })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
