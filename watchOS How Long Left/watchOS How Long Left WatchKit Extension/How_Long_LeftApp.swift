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
    
   
     
    let timelineGen: HLLTimelineGenerator
    
    @State var complicationPurchased = false
    
    init() {
        
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }
        
        HLLDataModel.shared = HLLDataModel()
        HLLEventSource.shared = HLLEventSource()
        
        HLLEventSource.shared.updateEvents()
        
        timelineGen = HLLTimelineGenerator(type: .complication)
       // EventLocationStore.shared = EventLocationStore()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .alert("Complication is now \(ComplicationStateManager.shared.complicationPurchased.description)", isPresented: $complicationPurchased, actions: {
                        
                        Button("Dismiss", action: {
                            complicationPurchased = false
                        })
                        
                    })
                    .onAppear() {
                        ComplicationStateManager.shared.addClosure(closure: { state in
                            
                            self.complicationPurchased = state
                            
                        })
                        
                    }
            }
            
        }
        
        WKNotificationScene(controller: HWShiftsNotificationController.self, category: "HWShifts")
    }
    
    
    
    
}
