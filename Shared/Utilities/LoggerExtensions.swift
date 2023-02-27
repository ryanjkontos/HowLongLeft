//
//  LoggerExtensions.swift
//  How Long Left
//
//  Created by Ryan Kontos on 9/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let defaultsSync = Logger(subsystem: subsystem, category: "CloudDefaultsSync")
}
