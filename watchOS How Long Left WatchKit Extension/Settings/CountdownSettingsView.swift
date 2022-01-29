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
                    Text("Show Large Countdown")
                })
                
                Toggle(isOn: $settingsObject.showSeconds.animation(), label: {
                    Text("Show Seconds")
                })
            
 
                
            })
            
            
            
            
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
    
    var showSecondsOnWristDown: Bool = HLLDefaults.watch.showSecondsWristDown {
        
        willSet {
            
            HLLDefaults.watch.showSecondsWristDown = newValue
            objectWillChange.send()
            
        }
        
    }
    
    
}
