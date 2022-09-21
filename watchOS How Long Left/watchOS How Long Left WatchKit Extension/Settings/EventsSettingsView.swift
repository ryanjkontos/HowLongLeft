//
//  EventsSettingsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventsSettingsView: View {
    
    @ObservedObject var settingsObject = WatchEventsSettingsObject()
    

    
    var body: some View {
        
        Form {
        
            Section {
                
                NavigationLink(destination: { HiddenEventsSettingsView() }, label: {
                    
                    Text("Hidden Events")
                    
                })
                
                NavigationLink(destination: { NicknamesListView() }, label: {
                    
                    Text("Nicknames")
                    
                })
                
            }
            

            
            Section(content: {
                
                Toggle("Combine Subsequent Events", isOn: Binding(get: { HLLDefaults.general.combineDoubles }, set: {
                    HLLDefaults.general.combineDoubles = $0
                    HLLEventSource.shared.asyncUpdateEventPool()
                }))
                
            }, footer: { Text("Combine groups of events that have the same title and occur immediately after each other as a single event.") })
            
        
    }
        .navigationTitle("Events")
        
    }
}

struct EventsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsSettingsView()
    }
}

class WatchEventsSettingsObject: ObservableObject {

  
    
    
    
    
    
}
