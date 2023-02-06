//
//  PreferencePaneIdentifiers.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 15/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Preferences

extension Preferences.PaneIdentifier {
    
    static let general = Self("general")
    static let menu = Self("menu")
    static let statusItem = Self("statusItem")
    static let calendars = Self("calendars")
    static let events = Self("events")
    static let calendarsNoAccess = Self("calendarsNoAccess")
    static let notifications = Self("notifications")
    static let customNotifications = Self("customNotifications")
    static let magdalene = Self("magdalene")
    static let magdaleneNotSetup = Self("magdaleneNotSetup")
    static let rename = Self("rename")
    static let widget = Self("widget")
    static let about = Self("about")
    static let purchasePro = Self("purchasePro")
    static let purchasedPro = Self("purchasedPro")
    
}
