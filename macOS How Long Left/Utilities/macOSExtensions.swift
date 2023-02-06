//
//  macOSExtensions.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 22/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit

public extension NSApplication {
    
    func relaunch(afterDelay seconds: TimeInterval = 0.5) -> Never {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "sleep \(seconds); open \"\(Bundle.main.bundlePath)\""]
        task.launch()
        
        self.terminate(nil)
        exit(0)
    }
}
