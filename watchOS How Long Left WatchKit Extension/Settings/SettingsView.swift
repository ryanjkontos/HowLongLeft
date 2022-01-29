//
//  SettingsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        Form {
        
        NavigationLink(destination: { CountdownSettingsView() }, label: {
            
            Text("Countdowns")
            
        })
            
            NavigationLink(destination: { EventsSettingsView() }, label: {
                
                Text("Events")
                
            })
            
            NavigationLink(destination: { EnabledCalendarsView()
                    .environmentObject(EnabledCalendarsManager())
            }, label: {
                
                Text("Calendars")
                
            })
            
            NavigationLink(destination: { ComplicationsSettingsView()

            }, label: {
                
                Text("Complication")
                
            })
            
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
