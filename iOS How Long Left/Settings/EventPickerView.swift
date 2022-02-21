//
//  EventPickerView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventPickerView: View {
    
    private var eventSelectionHandler: ((HLLEvent?) -> ())
    
    let datesOfEvents = HLLEventSource.shared.getAllEventsGroupedByDate()
    
    internal init(eventSelectionHandler: @escaping ((HLLEvent?) -> ())) {
        self.eventSelectionHandler = eventSelectionHandler
    }
    
    var body: some View {
        
        NavigationView {
            
            Group {
               
                if datesOfEvents.isEmpty {
                    
                    ZStack {
                        
                        #if os(iOS)
                        Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                        #endif
                        
                        Text("No Events")
                            .foregroundColor(.secondary)
                    }
                    
                } else {
                    list
                }
                
            }
            
            .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Select Event")
                .toolbar {
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { eventSelectionHandler(nil) }, label: { Text("Cancel") })
                    }
             
                }
                
            
            .tint(.orange)
            
           
            
        }
        
    }
    
    var list: some View {
         
            
            List {
                
                ForEach(datesOfEvents) { dateOfEvents in
                    
                    Section(dateOfEvents.date.userFriendlyRelativeString()) {
                        
                        ForEach(dateOfEvents.events) { event in
                            
                            Button(action: {
                                
                                eventSelectionHandler(event)
                                
                            }, label: {
                                
                                VStack(alignment: .leading) {
                                   
                                    Text(event.title)
                                        .foregroundColor(.primary)
                                    
                                    Text(event.startDate.formattedTime())
                                        .foregroundColor(.secondary)
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
           
            #if os(iOS)
            .listStyle(.grouped)
            
            #endif
        
        
    }
}

struct EventPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EventPickerView(eventSelectionHandler: { _ in })
    }
}
