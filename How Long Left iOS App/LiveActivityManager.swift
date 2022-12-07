//
//  LiveActivityManager.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 30/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
//import ActivityKit

@available(iOS 16.0, *)
class LiveActivityManager {
    
    static var shared = LiveActivityManager()
    
    func start(for event: HLLEvent) {
        
        /*  let eventAttributes = LiveEventAttributes(event: event)
         
         // Estimated delivery time is one hour from now.
         let initialContentState = LiveEventAttributes.LiveEventStatus(started: false)
         
         do {
         let eventActivity = try Activity<LiveEventAttributes>.request(
         attributes: eventAttributes,
         contentState: initialContentState,
         pushType: nil)
         // print("Requested an event Live Activity \(eventActivity.id)")
         } catch (let error) {
         // print("Error requesting event Live Activity \(error.localizedDescription)")
         }
         
         } */
        
        
    }
}

/*struct LiveEventAttributes: ActivityAttributes {
    public typealias LiveEventStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var started: Bool
        
    }

    var event: HLLEvent
}
*/
