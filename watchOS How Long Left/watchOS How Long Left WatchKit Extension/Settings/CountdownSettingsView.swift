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
   
    @State var currentValue: Int = HLLDefaults.watch.currentLimit
    @State var upcomingValue: Int = HLLDefaults.watch.upcomingLimit
    
    
    var body: some View {
        
        Form {
        
         
            
            Section(content: {
                
                
                
                Toggle(isOn: $settingsObject.showCurrent.animation(), label: {
                    Text("Show In-Progress Events")
                })
            
        
                
                Toggle(isOn: $settingsObject.upcomingMode.animation(), label: {
                    Text("Show Upcoming Events")
                })
              
                
                if settingsObject.showCurrent == true && settingsObject.upcomingMode == true{
                  
                    Picker(selection: $settingsObject.listOrderMode, content: {
                        
                        ForEach(WatchEventListOrderMode.allCases, id: \.self) { option in
                            Text(option.displayName)
                        }
                        
                    }, label: { Text("Sort Events...") })
                    
                    
                }
                
         
                
                
            }, header: {
                Text("Main Event List")
            }, footer: {

                    Text("Pinned events will always appear at the top of the main event list.")
                        
                
                
            })
            
             
            
            
            Section(content: {
        
                
                Toggle(isOn: $settingsObject.largeHeaderLocation, label: { Text("Show Locations") })
                Toggle(isOn: $settingsObject.percentages, label: { Text("Show Percentage Done") })
               

            }, header: {
                Text("Event Cards")
            })
            
            Section(content: {
                
                
                Toggle(isOn: $settingsObject.largeCurrentCard, label: {
                    Text("In-Progress Events")
                })
                
                Toggle(isOn: $settingsObject.largeUpcomingCard, label: {
                    Text("Upcoming Events")
                })
            

            }, header: {
                Text("Show Countdown Card For:")
            }, footer: {
                Text("Enable to use a taller event card that always displays a countdown. Otherwise, a more compact card that displays a smaller coutndown as part of a rotation between pieces of informational text will be used.")
            })
            
   
            
            
            if settingsObject.showCurrent == true || settingsObject.upcomingMode {
                
               
                Section("Event Limits") {
                    
                    if settingsObject.showCurrent {
                        
                        NavigationLink(destination: { EventLimitEditor(type: .current) }, label: {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("In-Progress Events Limit")
                                
                                Group {
                                    
                                    if currentValue == 0 {
                                        Text("No Limit")
                                    } else {
                                        Text("\(currentValue) Event\(currentValue == 1 ? "" : "s")")
                                    }
                                    
                                }
                                    .font(.system(size: 14.3, weight: .regular, design: .default))
                                    .foregroundColor(.secondary)
                            }
                            
                        })
                        
                    }
                    
                    if settingsObject.upcomingMode {
                        
                        NavigationLink(destination: { EventLimitEditor(type: .upcoming) }, label: {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Upcoming Events Limit")
                                
                                Group {
                                    
                                    if upcomingValue == 0 {
                                        Text("No Limit")
                                    } else {
                                        Text("\(upcomingValue) Event\(upcomingValue == 1 ? "" : "s")")
                                    }
                                    
                                }
                                
                                    .font(.system(size: 14.3, weight: .regular, design: .default))
                                    .foregroundColor(.secondary)
                            }
                            
                        })
                        
                    }
                }
                
            }
            
            
        }
        .onAppear(perform: {
            
            currentValue = HLLDefaults.watch.currentLimit
            upcomingValue = HLLDefaults.watch.upcomingLimit
            
        })
  
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("General")
        
    }
}

struct CountdownSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CountdownSettingsView()
        }
        
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
    
    var groupEvents: Bool = HLLDefaults.watch.groupEventsByDate {
        
        willSet {
            
            HLLDefaults.watch.groupEventsByDate = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var largeHeaderLocation: Bool = HLLDefaults.watch.largeHeaderLocation {
        
        willSet {
            
            HLLDefaults.watch.largeHeaderLocation = newValue
            objectWillChange.send()
            
        }
        
    }
    
    var percentages: Bool = HLLDefaults.watch.showPercentage {
        
        willSet {
            
            HLLDefaults.watch.showPercentage = newValue
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
    
    var upcomingMode = HLLDefaults.watch.showUpcoming {
        
        willSet {
            
            HLLDefaults.watch.showUpcoming = newValue
            objectWillChange.send()
            
        }
        
    }
    
    
    var largeCurrentCard = HLLDefaults.watch.largeCurrentCard {
        
        willSet {
            
            HLLDefaults.watch.largeCurrentCard = newValue
            objectWillChange.send()
            
        }
        
    }
    
    
    var largeUpcomingCard = HLLDefaults.watch.largeUpcomingCard {
        
        willSet {
            
            HLLDefaults.watch.largeUpcomingCard = newValue
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
