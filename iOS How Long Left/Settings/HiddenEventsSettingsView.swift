//
//  HiddenEventsSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct HiddenEventsSettingsView: View {
    
    @ObservedObject var store = HLLHiddenEventStore.shared
    
    @State var selectingEvent = false
    
    @State var showUnhideAlert = false
    @State var eventToUnhide: HLLStoredEvent?
    
    var body: some View {
        
        List {
            
    
                Section(content: {
                    
                    ForEach(store.hiddenEvents, content: { storedEvent in
                        
                        Button(action: {
                            
                            eventToUnhide = storedEvent
                            showUnhideAlert = true
                            
                        }) {
                            
                            VStack(alignment: .leading) {
                               
                                Text(storedEvent.title!)
                                    .foregroundColor(.primary)
                                
                                Text(storedEvent.endDate!.formattedTime())
                                    .foregroundColor(.secondary)
                                
                            }
                            
                        }
                            
                    })
                    .onDelete(perform: { index in
                        
                        withAnimation {
                          
                            if store.hiddenEvents.indices.contains(index.first!) {
                                let event = store.hiddenEvents[index.first!]
                                store.unhideEvent(event)
                                store.loadHiddenEventsFromDatabase()
                            }
                            
                        }
                        
                    })
                    
                    Button(action: { selectingEvent = true }, label: {
                        
                        Text("Hide Event")
                        
                    })
                    
                    
                }, header: { Text("Hidden Events") }, footer: {
                    
                        #if os(watchOS)
                            Text("Hidden events will not appear anywhere in How Long Left, including the complication.")
                        #else
                            Text("Hidden events will not appear anywhere in How Long Left, including the widget.")
                        #endif
                    
                })

            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Hidden Events")

        .alert(Text(getUnhideAlertText()), isPresented: $showUnhideAlert) {
            
            Button(role: .destructive , action: {
                
                
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        store.unhideEvent(eventToUnhide!)
                        store.loadHiddenEventsFromDatabase()
                    }
                }
                
                
            }, label: { Text("Unhide") })
            Button(role: .cancel, action: {}, label: { Text("Cancel") })
            
        }
        
        .sheet(isPresented: $selectingEvent) {
            
            EventPickerView { event in
                
                if let event = event { store.hideEvent(event) }
                store.loadHiddenEventsFromDatabase()
                selectingEvent = false
                
            }
            
        }
        
    }
    
    func getUnhideAlertText() -> String {
        
        if let eventToUnhide = eventToUnhide, let title = eventToUnhide.title {
            return "Unhide \"\(title)\"?"
        }
        
        return "Unhide Event?"
        
    }
}

struct HiddenEventsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HiddenEventsSettingsView()
    }
}
