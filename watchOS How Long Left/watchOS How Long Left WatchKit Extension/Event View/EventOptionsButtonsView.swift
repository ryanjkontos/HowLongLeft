//
//  EventOptionsButtonsView.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 20/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventOptionsButtonsView: View {
    
    @EnvironmentObject var dataObject: EventOptionsViewObject
    @Binding var nicknaming: HLLEvent?
    @Binding var presenting: Bool
    
    
    var body: some View {
         
        Group {
            
            Button(action: { dataObject.isPinned.toggle()
                
                dataObject.update()
                
            }, label: {
                
                
                Text("\(dataObject.isPinned ? "Unpin" : "Pin")")
                
            })
            .id(1)
            
            
            Button(action: {
                
                HLLStoredEventManager.shared.hideEvent(dataObject.event)
                
                self.presenting = false
                
            }, label: {
                Text("Hide This Event")
            })
            
            Button(action: { nicknaming = dataObject.event }, label: {
                
                if dataObject.event.isNicknamed {
                    Text("Manage Nickname")
                    
                } else {
                    Text("Set Nickname")
                }
                
                
            })
            
            Button(action: {
                
                
                CalendarDefaultsModifier.shared.setDisabled(calendar: dataObject.event.calendar!)
                
                self.presenting = false
                
                HLLEventSource.shared.updateEvents()
                
            }, label: {
                
                VStack(alignment: .leading) {
                   
                    Text("Hide Calendar")
                    
                    
                }
                
                
            })
            
        }
        
    }
}

struct EventOptionsButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        EventOptionsButtonsView(nicknaming: .constant(.previewEvent()), presenting: .constant(false))
    }
}
