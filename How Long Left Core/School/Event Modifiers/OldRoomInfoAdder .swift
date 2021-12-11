//
//  OldRoomInfoAdder .swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 30/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class OldRoomInfoAdder {
    
    static var shared = OldRoomInfoAdder()
    
    let changesDict = [
        
        // Block A
        
        " SA1":" 1",
        " SA2":" 2",
        " SA3":" 3",
        " SA4":" 4",
        " SA5":" 5",
        
        // Block B
        
        " B1":" 6",
        " B2":" 7",
        " B3":" 8",
        " B4":" 9",
        " B5":" 10",
        
        // Block C
        
        " C1":" 11",
        " C2":" 12",
        " C3":" 13",
        " C4":" 14",
        " C5":" 15",
        
        // Block D
        
        " D1":" 16",
        " D2":" 17",
        " D3":" 18",
        " D4":" 19",
        " D5":" 20",
        
        // CAPA
        
        " PA1":" PA4",
        " PA2":" D1",
        " PA3":" D2",
        " PA4":" M1",
        " PA5":" M2",
        " PA6":" PA1",
        " PA7":" PA2",
        " PA8":" PA3",
        
        // TAS Block
        
        " TS":" TX",
        " DS1":" C1",
        " DS2":" C2",
        " DS3":" C3",
        " DS4":" 22",
        " TT1":" T1",
        " TT2":" T2",
        
        // Hospitality Block
        
        " H1":" HOS",
        " H2":" FT2",
        " H3":" FT1",
        " H4":" 21",
    
        // Art Block
        
        " VA1":" A1",
        " VA2":" A2",
    
    ]
    
    func getOldRoom(for room: String) -> String? {
            
        var returnString: String?
            
        for item in changesDict {
                    
            if room.contains(text: item.key) {
                        
                returnString = room.replacingOccurrences(of: item.key, with: item.value)
                        
            }
                    
        }
        
        return returnString
        
        
    }
    
}
