//
//  EventInfoViewGenerator.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 10/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

class EventInfoViewGenerator {
    
    static var shared = EventInfoViewGenerator()
    
    func generateEventInfoView(for event: HLLEvent, isFollowingOccurence: Bool = false) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "EventInfoView") as! EventInfoViewController
        view.isFollowingOccurence = isFollowingOccurence
        view.event = event
        
        
       // let view = UIHostingController(rootView: EventInfoView(event: event))
        
        return view
        
    }
    
}
