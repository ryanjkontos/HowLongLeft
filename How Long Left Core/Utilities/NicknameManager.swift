//
//  NicknameManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class NicknameManager {
    
    static var shared = NicknameManager()
    
    private var dictionaryKey = "Nicknames"
    
    func addNicknames(for events: [HLLEvent]) -> [HLLEvent] {
        
        let nicknames = getNicknameDictionary()
        
        var returnArray = [HLLEvent]()
        
        for event in events {
            
            if let nickname = nicknames[event.originalTitle] {
                
                var nicknamed = event
                nicknamed.title = nickname
                nicknamed.isNicknamed = true
                
                returnArray.append(nicknamed)
                
            } else {
                returnArray.append(event)
            }
            
           
            
        }
        
        return returnArray
        
    }
    
    func setNickname(_ nickname: String?, for event: HLLEvent) {
        
        var dictionary = getNicknameDictionary()
        dictionary[event.originalTitle] = nickname
        saveNicknameDictionary(dictionary)
        HLLEventSource.shared.asyncUpdateEventPool()
        
    }

    private func getNicknameDictionary() -> [String:String] {
        
        var dictionary = [String:String]()
        
        #if os(macOS)
        
        if ProStatusManager.shared.isPro == false {
            return dictionary
        }
        
        #endif
        
        if let existingDictionary = HLLDefaults.defaults.dictionary(forKey: dictionaryKey) as? [String:String] {
            dictionary = existingDictionary
        }
        
        return dictionary
        
    }
    
    private func saveNicknameDictionary(_ dictionary: [String:String]) {
        HLLDefaults.defaults.set(dictionary, forKey: dictionaryKey)
    }
    
}
