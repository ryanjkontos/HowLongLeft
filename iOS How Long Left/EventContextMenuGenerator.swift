//
//  EventContextMenuGenerator.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 30/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
//import ActivityKit

class EventContextMenuGenerator {
    
    static var shared = EventContextMenuGenerator()
    
    func getContextMenu(for event: HLLEvent, coordinator: EventViewCoordinator? = nil) -> UIMenu {
        
        var items = [UIAction]()
        
        let pin = UIAction(title: "\(event.isPinned ? "Unpin":"Pin")", image: UIImage(systemName: "\(event.isPinned ? "pin.slash.fill":"pin.fill")")) { action in
             
            EventPinningManager.shared.togglePinned(event)
            
            HLLEventSource.shared.updateEventPool()
            coordinator?.updateEventSource()
            
        }
        
        items.append(pin)
        
        let hide = UIAction(title: "Hide This Event", image: UIImage(systemName: "eye.slash.fill")) { action in
            
            HLLHiddenEventStore.shared.hideEvent(event)
            
        }
        
        items.append(hide)
        
        let nickname = UIAction(title: event.isNicknamed ? "Manage Nickname" : "Add Nickname", image: UIImage(systemName: "character.cursor.ibeam")) { action in
            DispatchQueue.main.async {
                coordinator?.beginNicknaming()
            }
        }
        
        if event.isNicknamed {
            nickname.subtitle = "Original: \(event.originalTitle)"
        }
        
        items.append(nickname)
        
        let disable = UIAction(title: "Disable Calendar", subtitle: event.calendar?.title,image: UIImage(systemName: "calendar")) { action in
            
                
                CalendarDefaultsModifier.shared.setDisabled(calendar: event.calendar!)
                HLLEventSource.shared.updateEventPool()
            
            
        }
        
        items.append(disable)

        
        return UIMenu(title: "", children: items)
        
    }
    
}
