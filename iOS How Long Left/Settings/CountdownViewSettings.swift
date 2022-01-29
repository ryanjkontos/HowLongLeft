//
//  CountdownCardSettings.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownViewSettings: View {
    
    
    
    @ObservedObject var settingsObject = CountdownCardSettingsObject()
    
  
   
    
    @State private var isEditable = true
    
    let stepperRange = 1...50
    
    var body: some View {
  
        List {
            
            Section(content: {
                
                Toggle("Show Seconds", isOn: $settingsObject.showSeconds)
                
            }, header: {Text("Countdowns")})
            
            Section(content: {
                
                Toggle("Show In-Progress Events", isOn: $settingsObject.showInProgress)
                
                if settingsObject.showInProgress {
                    
                    Toggle("Ending Today Only", isOn: $settingsObject.onlyEndingToday)
                    
                }
                
            }, header: {
                
                Text("In Progress")
                
                
            }, footer: { Text("Only show In-Progress Events if they are scheduled to end today.") })
            
            
            Section(content: {
                
                
                Toggle("Show Upcoming Events", isOn: $settingsObject.showUpcoming)
                
                if settingsObject.showUpcoming {
                
                    
                    
                    Stepper(value: $settingsObject.upcomingCount, in: stepperRange, label: {
                        
                        Text("\(settingsObject.upcomingCount) Upcoming Event\(settingsObject.upcomingCount == 1 ? "" : "s")")
                        
                    })
                
            }
                
            }, header: { Text("Upcoming") })
            
            if settingsObject.showInProgress || settingsObject.showUpcoming {
            
                Section(content: {
                    
                    ForEach(settingsObject.sectionOrder, id: \.self) { section in
                        
                        Text(section.rawValue)
                            
                            .listRowInsets(EdgeInsets(top: 0, leading: -24,
                                            bottom: 0, trailing: 0))
                        
                    }
                    
                    .onMove(perform: move)
                    
                    
                }, header: { Text("Section Order")
                })
                
            }
         
        }
  
      /*  .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                
                Button(action: { showSheet = false }, label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .tint(.orange)
                })
                
            })
            
        }) */
        .animation(.default, value: settingsObject.showUpcoming)
        .animation(.default, value: settingsObject.showInProgress)
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Options")
       
        .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
       
        
        
        
    }
    
    
    func move(from source: IndexSet, to destination: Int) {
        settingsObject.sectionOrder.move(fromOffsets: source, toOffset: destination)
    }
    
    func incrementStep() {
        settingsObject.upcomingCount += 1
         
     }

     func decrementStep() {
         settingsObject.upcomingCount -= 1
         if settingsObject.upcomingCount < 1 { settingsObject.upcomingCount = 1 }
     }
}

struct CountdownCardSettings_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            CountdownViewSettings()
                
        }
        
        
    }
}


class CountdownCardSettingsObject: ObservableObject {

    var showSeconds: Bool = HLLDefaults.countdownsTab.showSeconds {
        
        willSet {
            
            HLLDefaults.countdownsTab.showSeconds = newValue
            
            updateSections()
            
            objectWillChange.send()
            
        }
        
    }
    
    var showInProgress: Bool = HLLDefaults.countdownsTab.showInProgress {
        
        willSet {
            
            HLLDefaults.countdownsTab.showInProgress = newValue
            
            updateSections()
            
            objectWillChange.send()
            
        }
        
    }
    
    var onlyEndingToday: Bool = HLLDefaults.countdownsTab.onlyEndingToday {
        
        willSet {
            
            HLLDefaults.countdownsTab.onlyEndingToday = newValue
            
            objectWillChange.send()
            
        }
        
    }
    
    
    var showUpcoming: Bool = HLLDefaults.countdownsTab.showUpcoming {
        
        willSet {
            
            HLLDefaults.countdownsTab.showUpcoming = newValue
            
            updateSections()
            
            objectWillChange.send()
            
        }
        
    }
    
    var upcomingCount: Int = HLLDefaults.countdownsTab.upcomingCount {
        
        willSet {
            
            print("Didset count to \(upcomingCount)")
            
            HLLDefaults.countdownsTab.upcomingCount = newValue
          
            objectWillChange.send()
            
        }
        
    }
    
    var cardBackground: CountdownCardAppearance = HLLDefaults.countdownsTab.cardAppearance {
        
        willSet {
            
            
            HLLDefaults.countdownsTab.cardAppearance = newValue
            objectWillChange.send()
            
        }
        
    }
    
    
    var sectionOrder: [CountdownTabSection] = HLLDefaults.countdownsTab.sectionOrder {
        
        willSet {
            
            HLLDefaults.countdownsTab.sectionOrder = newValue
            
            objectWillChange.send()
            
        }
        
    }
    
    
    func updateSections() {
        
        if HLLDefaults.countdownsTab.showInProgress == false {
            sectionOrder.removeAll(where: { $0 == .inProgress})
        } else {
            if sectionOrder.contains(.inProgress) == false {
                sectionOrder.append(.inProgress)
            }
        }
        
        if HLLDefaults.countdownsTab.showUpcoming == false {
            sectionOrder.removeAll(where: { $0 == .upcoming})
        } else {
            if sectionOrder.contains(.upcoming) == false {
                sectionOrder.append(.upcoming)
            }
        }
        
    }
    
}
