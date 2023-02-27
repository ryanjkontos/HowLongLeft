//
//  HiddenEventsSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct HiddenEventsSettingsView: View {
    
    @ObservedObject var store = HLLStoredEventManager.shared
    
    @State var selectingEvent = false
    
    @State var showUnhideAlert = false
    @State var eventToUnhide: HLLStoredEvent?
    
    var body: some View {
        
        List {
            
           
            
                Section(content: {
                    
                    Button(action: { selectingEvent = true }, label: {
                        
                        Text("Choose Event")
                        
                    })
                    
                    ForEach(store.hiddenEvents, content: { storedEvent in
                        
                        Button(action: {
                            
                            eventToUnhide = storedEvent
                            showUnhideAlert = true
                            
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
                                        
                                        store.unhideEvent(storedEvent)
                                        //store.loadStoredEventsFromDatabase()
                                        
                                    }
                                    
                                    
                                }
                                
                            }, label: {
                                
                                Label(title: {
                                    
                                    Text("Unhide")
                                    
                                }, icon: {
                                    
                                    Image(systemName: "xmark")
                                    
                                })
                                
                                
                            })
                            .tint(.red)
                            
                            
                        })
                            
                    })
                    
             
                    
                   /* .onDelete(perform: { index in
                        
                        
                        
                    }) */
                    
                   
                    
                    
                }, header: { Text("Hidden Events") }, footer: {
                    
                        #if os(watchOS)
                            Text("Hidden events will not appear anywhere in How Long Left, including the complication.")
                        #else
                            Text("Hidden events will not appear anywhere in How Long Left, including the widget.")
                        #endif
                    
                })

            
        }
        .animation(.easeInOut(duration: 0.5), value: store.hiddenEvents)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Hidden Events")

        .alert(Text(getUnhideAlertText()), isPresented: $showUnhideAlert) {
            
            Button(role: .destructive , action: {
                
                
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        store.unhideEvent(eventToUnhide!)
                        store.loadStoredEventsFromDatabase()
                    }
                }
                
                
            }, label: { Text("Unhide") })
            Button(role: .cancel, action: {}, label: { Text("Cancel")  })
               
            
        }
      
        
        .sheet(isPresented: $selectingEvent) {
            
            EventPickerView { event in
                
                if let event = event { store.hideEvent(event) }
                store.loadStoredEventsFromDatabase()
                selectingEvent = false
                
            }
            
        }
        
        .toolbar(content: {
            
            ToolbarItem(placement: .automatic, content: {
                
                Button(action: {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        store.unhideEvents(store.hiddenEvents)
                        
                    }
                    
                    
                }, label: {
                    Text("Unhide All")
                })
                .disabled(store.hiddenEvents.isEmpty)
                
            })
            
        })
        
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
        NavigationView {
            HiddenEventsSettingsView()
        }
    }
}
