//
//  EventsSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.to
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventsSettingsView: View {
    var body: some View {
        
        List {
            
            Section {
                
                
                Toggle("Show All-Day Events", isOn: Binding(get: { HLLDefaults.general.combineDoubles }, set: {
                    HLLDefaults.general.combineDoubles = $0
                    HLLEventSource.shared.asyncUpdateEventPool()
                }))
                
            }
            
            
            Section(content: {
              
                
                Toggle("Combine Subsequent Events", isOn: Binding(get: { HLLDefaults.general.combineDoubles }, set: {
                    HLLDefaults.general.combineDoubles = $0
                    HLLEventSource.shared.asyncUpdateEventPool()
                }))
                
            }, footer: { Text("Combine groups of events that have the same title and occur immediately after each other as a single event.") })
            
         /*   Section {
                
                NavigationLink(destination: { NicknamesListView() }, label: { Text("Manage Nicknames") })
                
                NavigationLink(destination: { HiddenEventsSettingsView() }, label: { Text("Manage Hidden Events") })
                
            } */
            
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct EventsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventsSettingsView()
        }
    }
}
