//
//  How_Long_LeftApp.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 2/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit

@main
struct How_Long_LeftApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostWillEnterForeground)) { _ in
                        HLLEventSource.shared.updateEventPool()
                    }
                    
            }
        }
        
    }
}
