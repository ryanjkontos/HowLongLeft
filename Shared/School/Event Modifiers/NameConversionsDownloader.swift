//
//  NameConversionsDownloader.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*
class NameConversionsDownloader {
    
    let subjectNamesURL = URL(string: "https://textuploader.com/16kx0/raw")!
    let teacherNamesURL = URL(string: "https://textuploader.com/16kxz/raw")!
    
    func downloadNames() {
        
        DispatchQueue.global().async {
            
            var changed = false
            
            if let namesDictionary = self.makeDictionary(from: self.subjectNamesURL) {
                
                if let previous = HLLDefaults.defaults.object(forKey: "NamesDictionary") as? [String:String] {
                    
                    if previous != namesDictionary {
                        HLLDefaults.defaults.set(namesDictionary, forKey: "NamesDictionary")
                        changed = true
                    }
                    
                } else {
                    
                    HLLDefaults.defaults.set(namesDictionary, forKey: "NamesDictionary")
                    changed = true
                    
                }
                
            }
            
            if let teachersDictionary = self.makeDictionary(from: self.teacherNamesURL) {
                
                if let previous = HLLDefaults.defaults.object(forKey: "TeachersDictionary") as? [String:String] {
                    
                    if previous != teachersDictionary {
                        HLLDefaults.defaults.set(teachersDictionary, forKey: "TeachersDictionary")
                        changed = true
                    }
                    
                } else {
                    
                    HLLDefaults.defaults.set(teachersDictionary, forKey: "TeachersDictionary")
                    changed = true
                    
                }
                
            }
            
            if changed {
                HLLEventSource.shared.updateEventPool()
                HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
            }
            
        }
        
    }
    
    func makeDictionary(from url: URL) -> [String:String]? {
        
        var returnDict = [String:String]()
        
        if let text = self.text(from: url) {
           
            let lines = text.split { $0.isNewline }
                
                for line in lines {
                    
                    if line.contains(" -> ") {
                        
                        let components = line.components(separatedBy: " -> ")
                        
                        if components.count == 2 {
                            
                            let key = components[0]
                            let value = components[1]
                            
                           // print("Setting: \(key) -> \(value)")
                            returnDict[key] = value
                            
                        }
                        
                    }
                    
                }
        
        } else {
            
            return nil
            
        }
        
        return returnDict
        
    }
    
    func text(from url: URL) -> String? {
        
            do {
                let contents = try String(contentsOf: url)
                return contents
            } catch {
                // contents could not be loaded
            }
        
        return nil
        
    }
    
}
*/
