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
                
            }
            
        Section(content: {
            
            Toggle(isOn: $settingsObject.showCurrent.animation(), label: {
                Text("Show In Progress Events")
            })
            
            Picker(selection: $settingsObject.upcomingMode.animation(), content: {
                
                ForEach(WatchUpcomingEventsDisplayMode.allCases, id: \.self) { option in
                    Text(option.displayName)
                }
                
            }, label: { Text("Show Upcoming Events") })
            
            if settingsObject.showCurrent == true && settingsObject.upcomingMode != .off {
              
                Picker(selection: $settingsObject.listOrderMode, content: {
                    
                    ForEach(WatchEventListOrderMode.allCases, id: \.self) { option in
                        Text(option.displayName)
                    }
                    
                }, label: { Text("Event Order") })
                
            }
            
            
        })
        
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

    var showCurrent: Bool = HLLDefaults.watch.showCurrent {
        
        willSet {
            
            HLLDefaults.watch.showCurrent = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var upcomingMode = HLLDefaults.watch.upcomingMode {
        
        willSet {
            
            HLLDefaults.watch.upcomingMode = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var listOrderMode = HLLDefaults.watch.listOrderMode {
        
        willSet {
            
            HLLDefaults.watch.listOrderMode = newValue
            objectWillChange.send()
            
        }
        
    }
    
    
    
    
    
}
