//
//  CountdownCardContextMenuModifier.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

struct CountdownCardContextMenuModifier: ViewModifier {
    
    var event: HLLEvent
    
    @Binding var nicknaming: HLLEvent?
    
    var reloadHandler: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .id(UUID())
            .contextMenu {
                
                Button(action: {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        if event.isPinned {
                            EventPinningManager.shared.unpinEvent(event)
                        } else {
                            EventPinningManager.shared.pinEvent(event)
                        }
                        
                    
                        reloadHandler()
                       
                        
                    }
                    
                }, label: {
                    Image(systemName: "\(event.isPinned ? "pin.slash.fill" : "pin.fill")")
                    Text("\(event.isPinned ? "Unpin" : "Pin")")
                    
                })
                
                Button(action: {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                    
                        HLLHiddenEventStore.shared.hideEvent(event)
                        
                        reloadHandler()
                       
                        
                    }
                    
                }, label: {
                    Image(systemName: "eye.slash.fill")
                    Text("Hide")
                    
                })
                
                Button(action: {
                    
                    DispatchQueue.main.async {
                        nicknaming = event
                    }
                    
                }, label: {
                    
                    if NicknameManager.shared.nicknameObjects.contains(where: { $0.originalName == event.originalTitle }) {
                        Label(title: { Text("Manage Nickname") }, icon: { Image(systemName: "character.cursor.ibeam") })
                    } else {
                        Label(title: { Text("Add Nickname") }, icon: { Image(systemName: "character.cursor.ibeam") })
                    }
                    
                    
                    
                })
                
                Button(action: {
                    
                    DispatchQueue.main.async {
                    
                        CalendarDefaultsModifier.shared.setDisabled(calendar: event.calendar!)
                        HLLEventSource.shared.updateEventPool()
                        
                        reloadHandler()
                        
                    }
                    
                }, label: {
                    
                    HStack {
                    
                    Image(systemName: "calendar")
                    Text("Disable Calendar")
                        
                    }
                    
                })
                
            }
          
              
    }
}
