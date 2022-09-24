//
//  PinnedEventsSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 22/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

import SwiftUI

struct PinnedEventsSettingsView: View {
    
    @ObservedObject var store = HLLStoredEventManager.shared
    
    @State var selectingEvent = false
    
    @State var showUnpinAlert = false
    @State var eventToUnpin: HLLStoredEvent?
    
    var body: some View {
        
        List {
            
          
                Section(content: {
                    
                    Button(action: { selectingEvent = true }, label: {
                        
                        Text("Pin Event")
                        
                    })
                    
                    
                    ForEach(store.pinnedEvents, content: { storedEvent in
                        
                        Button(action: {
                            
                            eventToUnpin = storedEvent
                            showUnpinAlert = true
                            
                        }) {
                            
                            VStack(alignment: .leading) {
                               
                                Text(storedEvent.title!)
                                    .foregroundColor(.primary)
                                
                                if let date = storedEvent.startDate {
                                    
                                    Text("\(date.formattedDate()), \(date.formattedTime())")
                                        .foregroundColor(.secondary)
                                    
                                }
                                
                              
                                
                            }
                            
                        }
                        .swipeActions(content: {
                            
                            Button(action: {
                                
                                withAnimation {

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        
                                        store.unpinEvent(storedEvent)
                                        //store.loadStoredEventsFromDatabase()
                                        
                                    }
                                    
                                    
                                }
                                
                            }, label: {
                                
                                Label(title: {
                                    
                                    Text("Unpin")
                                    
                                }, icon: {
                                    
                                    Image(systemName: "xmark")
                                        
                                    
                                })
                                
                                
                                
                            })
                            .tint(.red)
                            
                            
                        })
                            
                    })
                    
             
                    
                   /* .onDelete(perform: { index in
                        
                        
                        
                    }) */
                    
                    
                    
                    
                }, header: { Text("Pinned Events") }, footer: {
                    
                        #if os(watchOS)
                            Text("Pinned events are shown at the top of the events list. You can choose to make the Complication prefer to display pinned events over non-pinned events.")
                        #else
                        Text("Pinned events always appear in countdown tab, unless you disable this. You can choose to make Widgets prefer to display pinned events over non-pinned events.")
                        #endif
                    
                })

            
        }
        .animation(.easeInOut(duration: 0.5), value: store.pinnedEvents)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Pinned Events")

        .alert(Text(getUnpinAlertText()), isPresented: $showUnpinAlert) {
            
            Button(role: .destructive , action: {
                
                
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        store.unpinEvent(eventToUnpin!)
                        store.loadStoredEventsFromDatabase()
                    }
                }
                
                
            }, label: { Text("Unpin") })
            Button(role: .cancel, action: {}, label: { Text("Cancel")  })
               
            
        }
      
        
        .sheet(isPresented: $selectingEvent) {
            
            EventPickerView { event in
                
                if let event = event { store.pinEvent(event) }
                store.loadStoredEventsFromDatabase()
                selectingEvent = false
                
            }
            
        }
        
        .toolbar(content: {
            
            ToolbarItem(placement: .automatic, content: {
                
                Button(action: {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        store.unpinEvents(store.pinnedEvents)
                        
                    }
                    
                    
                }, label: {
                    Text("Unpin All")
                })
                .disabled(store.pinnedEvents.isEmpty)
                
            })
            
        })
        
    }
        
    
    func getUnpinAlertText() -> String {
        
        if let eventToUnpin = eventToUnpin, let title = eventToUnpin.title {
            return "Unpin \"\(title)\"?"
        }
        
        return "Unpin Event?"
        
    }
}

struct PinnedEventsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PinnedEventsSettingsView()
        }
    }
}


