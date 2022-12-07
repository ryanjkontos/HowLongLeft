//
//  AppKit Handler.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 8/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import AppKit

extension NSWindow {
    @objc func AirQuality_makeKeyAndOrderFront(_ sender: Any) {
        NSLog("[NSWindow] No window for you!")
    }
}

class HLLMacPluginClass: NSObject, HLLAppKitBundleProtocol {
    
    required override init() {
        
        super.init()
               
    
        
    }

    func launchMenuBarApp() {
        
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "ryankontos.How-Long-Left-Mac2") else { return }

        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        configuration.activates = true
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
        
       
        
    }
    
    func editWindow() {
        
       
        for window in NSApp.windows {
            // print(window)
        }
        
       // nsWin.styleMask.remove(.resizable)
       // nsWin.styleMask.remove(.fullSizeContentView)
        
    }
}
