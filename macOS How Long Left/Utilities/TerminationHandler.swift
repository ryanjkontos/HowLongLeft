//
//  TerminationHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit

class TerminationHandler {
    
    static var shared = TerminationHandler()
    
    @objc func terminateApp() {
        NSApplication.shared.terminate(self)
    }
    
}

