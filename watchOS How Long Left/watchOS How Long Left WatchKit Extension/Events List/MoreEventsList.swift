//
//  MoreEventsList.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 25/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct MoreEventsList: View {
    
    var objects = [DateOfEvents]()
    
    init(openSheet: Binding<Bool>) {
        
        let start = Date().startOfDay()
        let end = start.addDays(100)
        
        objects = HLLEventSource.shared.getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: false)
        
        _openSheet = openSheet
        
    }
    
    @Binding var openSheet: Bool
    
    var body: some View {
       
        TimelineView(.periodic(from: Date(), by: .second)) { context in
            
            List {
                
                ForEach(objects) { object in
                    
                    Section(content: {
                        
                        
                        ForEach(object.events) { event in
                            
                            
                            
                            NavigationLink(destination: {
                                EventView(event: event, open: .constant(nil), showToolbar: false)
                                
                            }, label: {
                                
                                if HLLDefaults.watch.upcomingMode == .withCountdown {
                                    CountdownCard(event: event, date: context.date)
                                } else {
                                    EventCard(event: event, liveUpdates: true)
                                }
                                
                                
                            })
                            
                            .listItemTint(Color(uiColor: event.color).opacity(0.25))
                            
                        }
                        
                        
                        
                        
                    }, header: {
                        
                        Text("\(object.date.userFriendlyRelativeString(at: context.date))")
                        
                    })
                    
                }
                
            }
            .toolbar(content: {
                
                ToolbarItem(placement: .cancellationAction, content: {
                    
                    Button(action: {
                        
                        openSheet = false
                        
                    }, label: {
                        
                        Text("Done")
                        
                    })
                    
                })
                
                
            })
            
        }
    
        
    }
}

struct MoreEventsList_Previews: PreviewProvider {
    static var previews: some View {
        MoreEventsList(openSheet: .constant(false))
    }
}