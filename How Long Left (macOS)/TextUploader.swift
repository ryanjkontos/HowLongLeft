//
//  TextUploader.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*

class TextUploader {
    
    static var shared = TextUploader()
    
    func uploadText(text: String, setTrueOnSuccess: String? = nil) {
        
        Pastr.pastebinApiKey = "63fa651d9adbdbe822824d8869ae21e4"
        Pastr.pastebinUserKey = "07227be29d9bb7a84916cf371c5db685"
        
        var name = "User"
        
        #if os(OSX)
        
        if let deviceName = Host.current().localizedName {
            name = deviceName
        }
        
        #endif
        
        Pastr.post(text: text, name: name, scope: .public, completion: {result in
            
            switch result {
                
            case .success(_):
                
                print("Upload successful")
                
                if let key = setTrueOnSuccess {
                    
                    HLLDefaults.defaults.set(true, forKey: key)
                    
                }
                
                
            case .failure(let error):
                
                print("Upload failed due to \(error)")

            }
            
        })
        
    }
    
    
}
*/
