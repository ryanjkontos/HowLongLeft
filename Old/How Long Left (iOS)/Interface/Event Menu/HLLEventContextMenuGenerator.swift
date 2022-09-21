//
//  HLLEventContextMenuGenerator.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 19/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import EventKit

@available(iOS 13.0, *)
class HLLEventContextMenuGenerator {
    
    static var shared = HLLEventContextMenuGenerator()
    
    let generator = HLLEventUniversalMenuItemGenerator()

    func generateContextMenuForEvent(_ event: HLLEvent, isFollowingOccurence: Bool = false) -> UIMenu? {
        
        let followingOccurence = event.followingOccurence != nil || isFollowingOccurence
        
        let menus = generator.generateUniversalMenuItems(for: event, isFollowingOccurence: followingOccurence)
        
        var contextMenus = [UIMenuElement]()
        
        for menu in menus {
            
            var contextMenuItems = [UIMenuElement]()
            
            for item in menu.items {
                
                let action = UIAction(title: item.title, image: item.image, identifier: nil, discoverabilityTitle: item.secondaryTitle, state: .off, handler: { _ in

                    item.action?()

                })
                
                contextMenuItems.append(action)
                
            }
           
            let uiMenu = UIMenu(title: "", options: .displayInline, children: contextMenuItems)
            contextMenus.append(uiMenu)
            
        }
        
        return UIMenu(title: event.title, children: contextMenus)
        
    }
   
}
