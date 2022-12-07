//
//  ComplicationStatusLogger.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class ComplicationStatusLogger {
    
    static let key = "ComplicationStatusLog"
    
    
    
   static func log(_ message: String) {
        
        let item = LogItem(message: message)
        
        var array = HLLDefaults.defaults.array(forKey: key) as? [Data] ?? [Data]()
        array.append(item.asData())
        HLLDefaults.defaults.set(array, forKey: key)
        
    }
    
    static func getLogItems() -> [LogItem] {
        
        var logItems = [LogItem]()
        
        guard let array = HLLDefaults.defaults.array(forKey: key) as? [Data] else { return logItems }
        
        let decoder = JSONDecoder()
        
        for item in array {
            
            let log = try! decoder.decode(LogItem.self, from: item)
            logItems.append(log)
            
        }
        
        return logItems.reversed()
        
    }
   
    struct LogItem: Codable, Identifiable, Equatable {
        
        var id: Date {
            return date
        }
        
        var date = Date()
        var message: String
       
        func asData() -> Data {
            
            let encoder = JSONEncoder()
            return try! encoder.encode(self)
        }
        
    }
    
}
