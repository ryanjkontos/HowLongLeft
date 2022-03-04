//
//  How_Long_LeftApp.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit


@main
struct How_Long_LeftApp: App {
    
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    
    //let communicationManager = CommunicationManager()
    
    let timelineGen = HLLTimelineGenerator(type: .complication)
    
    init() {
        HLLDataModel.shared = HLLDataModel()
        HLLEventSource.shared.updateEventPool()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            
        }
    }
    
    
}
