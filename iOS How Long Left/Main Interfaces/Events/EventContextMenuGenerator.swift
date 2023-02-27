//
//  EventContextMenuGenerator.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 30/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
#if !targetEnvironment(macCatalyst)
import ActivityKit
#endif

class EventContextMenuGenerator {
    
    static var shared = EventContextMenuGenerator()
    
    func getContextMenu(for event: HLLEvent, delegate: EventContextMenuDelegate?) -> UIMenu {
        
        var items = [UIAction]()
        
        let actionText = "\(event.isPinned ? "Unpin":"Pin")"
        
        let pin = UIAction(title: actionText, image: UIImage(systemName: "\(event.isPinned ? "pin.slash.fill":"pin.fill")")) { action in
             
            EventPinningManager.shared.togglePinned(event)
            
            HLLEventSource.shared.updateEvents(bypassDebouncing: true)
           
            delegate?.menuClosed()
            
            InfoAlertBox.shared.showAlert(text: "\(actionText)ned")
            
        }
        
        items.append(pin)
        
       
        
        let hide = UIAction(title: "Hide", image: UIImage(systemName: "eye.slash.fill")) { action in
            
            HLLStoredEventManager.shared.hideEvent(event)
            
            HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
            
            delegate?.closeEventView(event: event)
            
            delegate?.menuClosed()
            
            InfoAlertBox.shared.showAlert(text: "Hid Event")
            
            
            
        }
        
       
        
        items.append(hide)
        
#if !targetEnvironment(macCatalyst)
        
        if #available(iOS 16.1, *) {
            
            if let exisingActivity = LiveActivityStore().getActivityForEvent(event) {
                
                let endLA = UIAction(title: "End Activity", image: UIImage(systemName: "iphone")) { action in
                    
                  
                
                        
                        Task {
                            await exisingActivity.end(using: nil, dismissalPolicy: .immediate)
                        }
                        
                        
                        
                        InfoAlertBox.shared.showAlert(text: "Live Activity Ended")
                        
                        /* Task {
                         await activity.end(using: state, dismissalPolicy: ActivityUIDismissalPolicy.after(event.countdownDate))
                         } */
                        
                        
                    
                    
                    
                }
                
                items.append(endLA)
       
            } else {
                let startLA = UIAction(title: "Start Activity", image: UIImage(systemName: "iphone")) { action in
                    
                    let state = LiveEventAttributes.ContentState.init()
                    let attributes = LiveEventAttributes(event: event)
                    
                    do {
                        
                        let activity = try Activity.request(attributes: attributes, contentState: state)
                        
                        
                        InfoAlertBox.shared.showAlert(text: "Live Activity Started")
                        
                        /* Task {
                         await activity.end(using: state, dismissalPolicy: ActivityUIDismissalPolicy.after(event.countdownDate))
                         } */
                        
                        
                        
                    } catch (let error) {
                        print("Error requesting stock trade Live Activity: \(error.localizedDescription).")
                    }
                    
                    
                }
                
                items.append(startLA)
            }
            
        }
        
        
        #endif
        
        let nickname = UIAction(title: event.isNicknamed ? "Manage Nickname" : "Add Nickname", image: UIImage(systemName: "character.cursor.ibeam")) { action in
           
            delegate?.nicknameEvent(event: event)
            
            delegate?.menuClosed()
            
        }
        
        if event.isNicknamed {
            nickname.subtitle = "Original: \(event.originalTitle)"
        }
        
        items.append(nickname)
        
        let disable = UIAction(title: "Hide Calendar", subtitle: event.calendar?.title,image: UIImage(systemName: "calendar")) { action in
            
            guard let cal = event.calendar else {
                InfoAlertBox.shared.showAlert(text: "Event Has No Calendar")
                return
            }
                
                CalendarDefaultsModifier.shared.setDisabled(calendar: event.calendar!)
                delegate?.closeEventView(event: event)
                delegate?.menuClosed()
                HLLEventSource.shared.updateEvents(bypassDebouncing: true)
            
            InfoAlertBox.shared.showAlert(text: "Calendar Hidden")
            
            
        }
        
        
        
        items.append(disable)

        
        return UIMenu(title: "", children: items)
        
    }
    
}
