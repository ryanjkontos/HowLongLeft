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
                
                
                Toggle("Show All-Day Events", isOn: Binding(get: { HLLDefaults.general.showAllDay }, set: {
                    HLLDefaults.general.showAllDay = $0
                    HLLEventSource.shared.asyncUpdateEventPool()
                }))
                
            }
            
            
            Section(content: {
              
                
                Toggle("Combine Back To Back Events", isOn: Binding(get: { HLLDefaults.general.combineDoubles }, set: {
                    HLLDefaults.general.combineDoubles = $0
                    HLLEventSource.shared.asyncUpdateEventPool()
                }))
                
            }, footer: { Text("Enabling this option will cause How Long Left to display back-to-back events with the same title as a single, combined event.") })
            
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
