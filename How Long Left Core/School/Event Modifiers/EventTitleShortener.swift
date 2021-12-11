//
//  EventTitleShortener.swift
//  How Long Left
//
//  Created by Ryan Kontos on 16/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class EventTitleShortener {
    
    static let shared = EventTitleShortener()
    
    func shortenTitle(events: [HLLEvent]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        for eventItem in events {
            
            var event = eventItem
            
        if event.isSchoolEvent == true {
            
        var newTitle = event.title
        var ultraCompact: String?
        
            if event.originalTitle.contains(text:"Food Technology") {
                newTitle = "Food Tech"
                ultraCompact = "FT"
            }
                
            if event.originalTitle.contains(text:"FTH") {
                newTitle = "Food Tech"
                ultraCompact = "FT"
            }
            
            if event.originalTitle.contains(text:"Science") {
                newTitle = "Science"
                ultraCompact = "SCI"
            }
            
            if event.originalTitle.contains(text:"Mathematics") {
                newTitle = "Math"
            }
            
            if event.originalTitle.contains(text:"English") {
                newTitle = "English"
                ultraCompact = "ENG"
            }
            
            
        if event.originalTitle.contains(text:"Pastoral Care") {
            newTitle = "Homeroom"
            ultraCompact = "PC"
        }
        
        if event.originalTitle.contains(text:"Information Software Technology") {
            newTitle = "IST"
        }
            
        if event.originalTitle.contains(text:"Information Process Technology") {
            newTitle = "IPT"
        }
           
        if event.originalTitle.contains(text:"Design"), event.originalTitle.contains(text:"Technology")  {
            newTitle = "D&T"
        }
            
        if event.originalTitle.contains(text:"Software Design") {
            newTitle = "SDD"
        }
            
        if event.originalTitle.contains(text:"Commerce") {
            newTitle = "Commerce"
            ultraCompact = "Cmrce"
        }
                
        if event.originalTitle.contains(text:"COM") {
            newTitle = "Commerce"
        }
            
        if event.originalTitle.contains(text:"Arts") {
            newTitle = "Art"
        }
                
        if event.originalTitle.contains(text:"ART") {
            newTitle = "Art"
        }
            
        if event.originalTitle.contains(text:"Drama") {
            newTitle = "Drama"
        }
            
        if event.originalTitle.contains(text:"PAS") {
            newTitle = "PASS"
        }
        
        if event.title == "Sport" {
            if HLLDefaults.magdalene.showSportAsStudy {
                newTitle = "Study"
            } else {
                newTitle = "Sport"
            }
        }
        
        if event.originalTitle.contains(text:"HSIE") {
            newTitle = "History"
            ultraCompact = "HIST"
        }
        
            
            
        if event.originalTitle.contains(text:"History") {
            newTitle = "History"
            ultraCompact = "HIST"
        }
        
        if event.originalTitle.contains(text:"History Elective") {
            newTitle = "HEL"
        }
            
        if event.originalTitle.contains(text:"Ancient History") {
            newTitle = "Ancient"
        }
        
        if event.originalTitle.contains(text:"Music") {
            newTitle = "Music"
        }
                
        if event.originalTitle.contains(text:"MUS") {
            newTitle = "Music"
        }
        
        if event.originalTitle.contains(text:"Maths") {
            newTitle = "Math"
        }
        
        if event.originalTitle.contains(text:"PDHPE") {
            newTitle = "PDHPE"
            ultraCompact = "PDH"
        }
        
        if event.originalTitle.contains(text:"Geography") {
            newTitle = "Geography"
        }
            
        if event.originalTitle.contains(text:"Geography Elective") {
            newTitle = "GEL"
        }
        
        if event.originalTitle.contains(text:"GEL") {
            newTitle = "GEL"
        }
        
        if event.originalTitle.contains(text:"Early Childhood") {
            newTitle = "EEC"
        }
            
        if event.originalTitle.contains(text:"CAFS") {
            newTitle = "CAFS"
        }
                
        if event.originalTitle.contains(text:"CAF") {
            newTitle = "CAFS"
        }
            
        if event.originalTitle.contains(text:"SAC") {
            newTitle = "SAC"
        }
            
        if event.originalTitle.contains(text:"Business Studies") {
            newTitle = "Business"
            ultraCompact = "BS"
        }
            
        if event.originalTitle.contains(text:"Business Services") {
            newTitle = "Business"
            ultraCompact = "BS"
        }
            
        if event.originalTitle.contains(text:"BST") {
            newTitle = "Business Studies"
        }
                
        if event.originalTitle.contains(text:"BSE") {
            newTitle = "Business Services"
        }
            
        if event.originalTitle.contains(text:"IST") {
            newTitle = "IST"
        }
        
        if event.originalTitle.contains(text:"Religion") {
            newTitle = "Religion"
            ultraCompact = "RE"
        }
            
        if event.originalTitle.contains(text:"Chemistry") {
            newTitle = "Chemistry"
            ultraCompact = "Chem"
        }
            
        if event.originalTitle.contains(text:"Biology") {
            newTitle = "Biology"
            ultraCompact = "Bio"
        }
        
        if event.originalTitle.contains(text:"Physics") {
            newTitle = "Physics"
            ultraCompact = "PHYS"
        }
            
        if event.originalTitle.contains(text:"Photography") {
            newTitle = "Photography"
            ultraCompact = "PHO"
        }
          
        if event.originalTitle.contains(text:"Study") {
            newTitle = "Study"
        }
                
        if event.originalTitle.contains(text:"STUDY") {
            newTitle = "Study"
        }
        
        if event.originalTitle.contains(text:"Drama") {
            newTitle = "Drama"
        }
            
        if event.originalTitle.contains(text:"Legal") {
            newTitle = "Legal"
        }
                
        if event.originalTitle.contains(text:"SDD") {
            newTitle = "SDD"
        }
                
        if event.originalTitle.contains(text:"IPT") {
            newTitle = "IPT"
        }
                
        if event.originalTitle.contains(text:"MS") {
            newTitle = "Math"
        }
                
        if event.originalTitle.contains(text:"EN") {
            newTitle = "English"
        }
                
        if event.originalTitle.contains(text:"MHI") {
            newTitle = "Modern"
        }
                
        if event.originalTitle.contains(text:"AHI") {
            newTitle = "Ancient"
        }
                
        if event.originalTitle.contains(text:"PHO") {
            newTitle = "Photography"
        }
                
        if event.originalTitle.contains(text:"SR") {
            newTitle = "Religion"
        }
                
        if event.originalTitle.contains(text:"PDH") {
            newTitle = "PDH"
        }
                
        if event.originalTitle.contains(text:"BIO") {
            newTitle = "Biology"
        }
                
        if event.originalTitle.contains(text:"PHY") {
            newTitle = "Physics"
        }
                
        if event.originalTitle.contains(text:"PHS") {
            newTitle = "Physics"
        }
                
        if event.originalTitle.contains(text:"CHE") {
            newTitle = "Chemistry"
        }
                
        if event.originalTitle.contains(text:"EEC") {
            newTitle = "EEC"
        }
            
        if event.originalTitle.contains(text:"DAT") {
            newTitle = "D&T"
        }
                
        if event.originalTitle.contains(text:"D&T") {
            newTitle = "D&T"
        }
                
        if event.originalTitle.contains(text:"DES") {
            newTitle = "D&T"
        }
                
        if event.originalTitle.contains(text:"DRA") {
            newTitle = "Drama"
        }
        
        if event.originalTitle.contains(text:"DMA") {
            newTitle = "Drama"
        }
                
        if event.originalTitle.contains(text:"SCI") {
            newTitle = "Science"
        }
                
        if event.originalTitle.contains(text:"CS") {
            newTitle = "Catholic Studies"
        }
            
        if event.originalTitle.contains(text:"MEX") {
            newTitle = "Catholic Studies"
        }
                
        if event.period == "H" {
            newTitle = "Homeroom"
        }
          
        if event.originalTitle.contains(text:"SPST") {
            newTitle = "Study"
            ultraCompact = "Study"
        }
        
                
        if let dict = HLLDefaults.defaults.object(forKey: "NamesDictionary") as? [String:String] {
                
            for item in dict {
            
                if event.originalTitle.lowercased().contains(text: item.key.lowercased()) {
                    
                    if item.value == "*" {
                        newTitle = event.originalTitle
                    } else {
                        newTitle = item.value
                    }
                    
                }
                
            }
                
        }
        
        
        if event.title == "Sport", HLLDefaults.magdalene.showSportAsStudy {
            newTitle = "Study"
        }
            
                
        event.title = newTitle
        event.shortTitle = newTitle
            
        if let UC = ultraCompact {
                
         event.ultraCompactTitle = UC
                
        } else {
            
        event.ultraCompactTitle = newTitle
            
        }
                
            }
            
        returnArray.append(event)
            
        }
            
            
        
        return returnArray
        
    }
    
}
