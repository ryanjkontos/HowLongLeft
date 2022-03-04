//
//  WatchModel.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class WatchModel {
    
    var alwaysOnSupported: Bool {
         return supportsAlwaysOn(modelString: getWatchModel())
    }
    
    private func getWatchModel() -> String? {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = CChar()
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: &machine, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    ///  Returns true if the watch supports always on. Also returns true if any error is encountered, since it is safer to show options to users that don't actually need them then it is to hide them from users that do.
    func supportsAlwaysOn(modelString: String?) -> Bool {
        
        guard var modelName = modelString else { return true }
        modelName = modelName.replacingOccurrences(of: "Watch", with: "")
        let items = modelName.components(separatedBy: ",")
        guard items.count == 2 else { return true }
        guard let first = Int(items[0]) else { return true }
        guard let second = Int(items[1]) else { return true }
        if first < 5 { return false } // Exclude anything less than Series 5.
        if first == 5, second > 4 { return false } // Exclude SE.
        return true
        
    }
    
}
