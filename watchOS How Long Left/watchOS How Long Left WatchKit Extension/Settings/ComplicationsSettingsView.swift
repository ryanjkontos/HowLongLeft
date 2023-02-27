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
    
    @State var enabledCount = CalendarDefaultsModifier.privateComplicationShared.enabledCalendars.count
    
    var body: some View {
        
        Form {
            
            #if os(iOS)
            
            Section(content: {EmptyView()}, footer: {
                Text("This menu currently does nothing on iOS. Please use the Complication settings menu on your Apple Watch.")
            })
            
            #endif
            
            if HLLDefaults.complication.complicationPurchased {
                
                Section {
                    
                    
                    
                    ComplicationDisabledHeader()
                    //.padding(.top, 20)
                    //.padding(.bottom, 40)
                        .listItemTint(.clear)
                    
                }
                
            }
            
            
            Group {
                
               // .disabled(true)
                
                if model.complicationEnabled {
                    
                    Section("Events") {
                        
                        Toggle("Prefer Showing Pinned Events", isOn: $model.config.alwaysShowPinned.animation())
                        
                        Toggle("Show In Progress Events", isOn: $model.config.showCurrent.animation())
                        Toggle("Show Upcoming Events", isOn:  $model.config.showUpcoming.animation())
                        
                        
                        
                        
                    }
                  //  .disabled(true)
                    
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
               
              
                    
                }
                
                
            }
           // .disabled(true)
           
            Section("Calendars", content: {
                
                Toggle("Mirror App Calendars", isOn: $model.mirrorCalendars.animation())
                
                if !model.mirrorCalendars {
                    
                    NavigationLink(destination: { NavigationLazyView(EnabledCalendarsView(calendarsManager: ComplicationEnabledCalendarsManager.shared, contextWord: "complication")
                            .environmentObject(ComplicationEnabledCalendarsManager.shared))
                    }, label: {
                  
                        VStack(alignment: .leading) {
                            
                            Text("Choose Calendars...")
                            Text("\(enabledCount) Enabled")
                                
                                .foregroundColor(.secondary)
                        }
                       
                        
                    })
                    .onAppear() {
                        enabledCount = CalendarDefaultsModifier.privateComplicationShared.enabledCalendars.count
                    }
                    
                }
                
            })
            
            Section(content: {
                NavigationLink(destination: {
                    NavigationLazyView(ComplicationInfoTextSettingsView())
                }, label: {
                    Text("Large Rectangular Complication Settings")
                })
            }, footer: {
                Text("Options specific to the Large Rectangular complication avaliable on some watch faces, such as the Modular face.")
            })
            
        }
        
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Complication")
        
    }
}

struct ComplicationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComplicationsSettingsView()
        }
    }
}

class ComplicationSettingsObject: ObservableObject {

    var config = ComplicatonConfigurationManager().getConfig() {
        
        willSet {
            
            ComplicatonConfigurationManager().saveConfig(newValue)
            objectWillChange.send()
            update()
                
        }
        
    }
    
    var complicationEnabled: Bool = HLLDefaults.watch.complicationEnabled {
        
        willSet {
            
            HLLDefaults.watch.complicationEnabled = newValue
            objectWillChange.send()
            update()
                
        }
        
    }
    
    var tint: Bool = HLLDefaults.complication.tintComplication {
        
        willSet {
            
            HLLDefaults.complication.tintComplication = newValue
            objectWillChange.send()
            update()
                
        }
        
    }
    
    var showSeconds: Bool = HLLDefaults.complication.showSeconds {
        
        willSet {
            
            HLLDefaults.complication.showSeconds = newValue
            objectWillChange.send()
            update()
                
        }
        
    }
    
    var showUnits: Bool = HLLDefaults.complication.unitLabels {
        
        willSet {
            
            HLLDefaults.complication.unitLabels = newValue
            objectWillChange.send()
            update()
                
        }
        
    }
    
    var mirrorCalendars: Bool = HLLDefaults.complication.mirrorCalendars {
        
        willSet {
            
            HLLDefaults.complication.mirrorCalendars = newValue
            objectWillChange.send()
            update()
        }
        
    }
    
    func update() {
        #if os(watchOS)
        ComplicationController.updateComplications(forced: true)
            
        #else
        #endif
    }
    
}
