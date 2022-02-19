//
//  ComplicationsSettingsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationsSettingsView: View {
    
    @ObservedObject var model = ComplicationSettingsObject()
    
    @State var sortMode: TimelineSortMode = .chronological
    
    var body: some View {
        
        Form {
            
            Section {
                Toggle(isOn: $model.complicationEnabled.animation(), label: { Text("Show Events") })
            }
            
            if model.complicationEnabled {
            
                Section("Events") {
                    
                    Toggle("Show In Progress Events", isOn: $model.config.showCurrent.animation())
                    Toggle("Show Upcoming Events", isOn:  $model.config.showUpcoming.animation())
                    
                    
                    
                    
                }
                
                if model.config.showCurrent, model.config.showUpcoming {
                
                    Section("Prefer Showing") {
                        
                        Picker(selection: $model.config.sortMode.animation(), content: {
                            ForEach(TimelineSortMode.allCases) { option in
                                Text("\(option.name)")
                            }
                        }, label: { })
                        .pickerStyle(.inline)
                        
                    }
                    
                }
                
                Section("Appearance") {
                    
                    Toggle(isOn: $model.showUnits, label: { Text("Show Time Units") })
                    Toggle(isOn: $model.showSeconds, label: { Text("Show Seconds") })
                    
                    Toggle(isOn: $model.tint, label: { Text("Tint Complication") })
                    
                }
                
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Complication")
        
    }
}

struct ComplicationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationsSettingsView()
    }
}

class ComplicationSettingsObject: ObservableObject {

    var config = ComplicatonConfigurationManager().getConfig() {
        
        willSet {
            
            ComplicatonConfigurationManager().saveConfig(newValue)
            objectWillChange.send()
            ComplicationController.updateComplications(forced: true)
                
        }
        
    }
    
    var complicationEnabled: Bool = HLLDefaults.watch.complicationEnabled {
        
        willSet {
            
            HLLDefaults.watch.complicationEnabled = newValue
            objectWillChange.send()
            ComplicationController.updateComplications(forced: true)
                
        }
        
    }
    
    var tint: Bool = HLLDefaults.complication.tintComplication {
        
        willSet {
            
            HLLDefaults.complication.tintComplication = newValue
            objectWillChange.send()
            ComplicationController.updateComplications(forced: true)
                
        }
        
    }
    
    var showSeconds: Bool = HLLDefaults.complication.showSeconds {
        
        willSet {
            
            HLLDefaults.complication.showSeconds = newValue
            objectWillChange.send()
            ComplicationController.updateComplications(forced: true)
                
        }
        
    }
    
    var showUnits: Bool = HLLDefaults.complication.unitLabels {
        
        willSet {
            
            HLLDefaults.complication.unitLabels = newValue
            objectWillChange.send()
            ComplicationController.updateComplications(forced: true)
                
        }
        
    }
    
}
