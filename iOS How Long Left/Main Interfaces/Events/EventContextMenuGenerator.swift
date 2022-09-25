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
    
    func getContextMenu(for event: HLLEvent, delegate: EventContextMenuDelegate?) -> UIMenu {
        
        var items = [UIAction]()
        
        let pin = UIAction(title: "\(event.isPinned ? "Unpin":"Pin")", image: UIImage(systemName: "\(event.isPinned ? "pin.slash.fill":"pin.fill")")) { action in
             
            EventPinningManager.shared.togglePinned(event)
            
            HLLEventSource.shared.updateEventPool()
           
            
        }
        
        items.append(pin)
        
        let hide = UIAction(title: "Hide This Event", image: UIImage(systemName: "eye.slash.fill")) { action in
            
            HLLStoredEventManager.shared.hideEvent(event)
            
            delegate?.closeEventView(event: event)
            
        }
        
        items.append(hide)
        
        let nickname = UIAction(title: event.isNicknamed ? "Manage Nickname" : "Add Nickname", image: UIImage(systemName: "character.cursor.ibeam")) { action in
           
            delegate?.nicknameEvent(event: event)
            
        }
        
        if event.isNicknamed {
            nickname.subtitle = "Original: \(event.originalTitle)"
        }
        
        items.append(nickname)
        
        let disable = UIAction(title: "Hide Calendar", subtitle: event.calendar?.title,image: UIImage(systemName: "calendar")) { action in
            
                
                CalendarDefaultsModifier.shared.setDisabled(calendar: event.calendar!)
                delegate?.closeEventView(event: event)
                HLLEventSource.shared.updateEventPool()
            
            
        }
        
        
        
        items.append(disable)

        
        return UIMenu(title: "", children: items)
        
    }
    
}
