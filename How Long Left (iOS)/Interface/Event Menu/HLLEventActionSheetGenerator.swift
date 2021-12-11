//
//  HLLEventActionSheetGenerator.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 23/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit

class HLLEventActionSheetGenerator {
    
    static var shared = HLLEventActionSheetGenerator()
    
    let generator = HLLEventUniversalMenuItemGenerator()
    
    func generateActionSheet(for event: HLLEvent, isFollowingOccurence: Bool = false) -> UIAlertController {
        
        var style = UIAlertController.Style.actionSheet
        #if targetEnvironment(macCatalyst)
        style = .alert
        #endif
        
        if UIDevice.current.userInterfaceIdiom == .pad {
           style = .alert
        }
        
        let actionSheet = UIAlertController(title: event.title, message: nil, preferredStyle: style)
        
        let followingOccurence = event.followingOccurence != nil || isFollowingOccurence
        
        let menus = generator.generateUniversalMenuItems(for: event, isFollowingOccurence: followingOccurence)
        
        for menu in menus {
            
            for item in menu.items {
                
                let action = UIAlertAction(title: item.combinedTitle, style: .default, handler: { _ in
                    item.action?()
                })
                
                       
                actionSheet.addAction(action)
                
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        return actionSheet

    }
    
}
