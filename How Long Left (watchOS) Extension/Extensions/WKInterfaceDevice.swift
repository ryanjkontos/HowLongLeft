//
//  WKInterfaceDevice.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 22/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit

extension WKInterfaceDevice {
class func currentResolution() -> WatchResolution {
    let watch38mmRect = CGRect(x: 0, y: 0, width: 136, height: 170)
    let watch40mmRect = CGRect(x: 0, y: 0, width: 162, height: 197)
    let watch42mmRect = CGRect(x: 0, y: 0, width: 156, height: 195)
    let watch44mmRect = CGRect(x: 0, y: 0, width: 184, height: 224)

    let currentBounds = WKInterfaceDevice.current().screenBounds

    switch currentBounds {
    case watch38mmRect:
        return .Watch38mm
    case watch40mmRect:
        return .Watch40mm
    case watch42mmRect:
        return .Watch42mm
    case watch44mmRect:
        return .Watch44mm
    default:
        return .Unknown
    }
  }
}
