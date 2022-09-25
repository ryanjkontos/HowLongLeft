//
//  EventContextMenuDelegate.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

protocol EventContextMenuDelegate {
    
    func nicknameEvent(event: HLLEvent)
    func closeEventView(event: HLLEvent)
    
}
