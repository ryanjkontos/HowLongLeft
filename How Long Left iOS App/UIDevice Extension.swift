//
//  UIDevice Extension.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 30/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
