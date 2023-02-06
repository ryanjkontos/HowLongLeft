//
//  InProgressEventsList.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 17/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct InProgressEventsList: View {
    
    
    init(openSheet: Binding<Bool>) {
        
        
        _openSheet = openSheet
        
    }
    
    @Binding var openSheet: Bool
    
    func getEvents(at date: Date) -> [HLLEvent] {
        return HLLEventSource.shared.getCurrentEvents(date: date)
    }
    
    var body: some View {
       
        TimelineView(.periodic(from: Date(), by: .second)) { context in
            
            List {
                
                ForEach(getEvents(at: context.date)) { event in
                    
                    NavigationLink(destination: {
                        EventView(event: event, open: .constant(nil), showToolbar: false)
                        
                    }, label: {
                        CountdownCard(event: event, date: context.date, referenceDate: .constant(Date()))
                    })
                    
                    .listItemTint(Color(uiColor: event.color).opacity(0.25))
                    
                }
                
            }
            .navigationTitle("In-Progress")
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


struct InProgressEventsList_Previews: PreviewProvider {
    static var previews: some View {
        InProgressEventsList(openSheet: .constant(false))
    }
}
