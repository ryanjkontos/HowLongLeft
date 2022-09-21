//
//  CountdownSettingsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownSettingsView: View {
    
    let model = WatchModel()
    
    @ObservedObject var settingsObject = WatchCountdownSettingsObject()
    
    var body: some View {
        
        Form {
        
            Section(content: {
                
                Toggle(isOn: $settingsObject.largeHeader, label: {
                    Text("Show First Event Large")
                })
                
                
                Toggle(isOn: $settingsObject.largeHeaderLocation, label: { Text("Show Locations") })
                    

            })
            
            
            Section {
                
                Toggle(isOn: $settingsObject.showSeconds.animation(), label: {
                    Text("Show Seconds")
                })
                
            }
            
            Section {
                
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
                
                
            }
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Countdowns")
        
    }
}

struct CountdownSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownSettingsView()
    }
}


class WatchCountdownSettingsObject: ObservableObject {

    var largeHeader: Bool = HLLDefaults.watch.largeCell {
        
        willSet {
            
            HLLDefaults.watch.largeCell = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var showSeconds: Bool = HLLDefaults.watch.showSeconds {
        
        willSet {
            
            HLLDefaults.watch.showSeconds = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var largeHeaderLocation: Bool = HLLDefaults.watch.largeHeaderLocation {
        
        willSet {
            
            HLLDefaults.watch.largeHeaderLocation = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var showSecondsOnWristDown: Bool = HLLDefaults.watch.showSecondsWristDown {
        
        willSet {
            
            HLLDefaults.watch.showSecondsWristDown = newValue
            objectWillChange.send()
            
        }
        
    }
    
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
