//
//  HLLAppKitBundleProtocol.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 8/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
@objc(Plugin)
protocol HLLAppKitBundleProtocol: NSObjectProtocol {
    
    init()

    func launchMenuBarApp()
    func editWindow()
}
