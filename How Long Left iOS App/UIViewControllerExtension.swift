//
//  UIViewControllerExtension.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func rootedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}
