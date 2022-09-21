//
//  StatusItemGlobals.swift
//  How Long Left (macOS)
//
//  Created by Ryan on 29/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class StatusItemGlobals {
    
    
    static let textAttribute = [ NSAttributedString.Key.font: NSFont.monospacedDigitSystemFont(ofSize: 13.0, weight: .regular)]
    static let selectedIcon = NSImage(named: NSImage.menuOnStateTemplateName)
    static let basicIcon = NSImage(named: "statusIcon")!
    static let colourIcon = NSImage(named: "ColourSI")!
    
    static var currentIcon: NSImage {
        get { return basicIcon }
    }
    
    static let activeAlpha: CGFloat = 1.0
    static let inactiveAlpha: CGFloat = 0.5
    
}
