//
//  HotKeyHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import HotKey

class HotKeyHandler {
    
    static var shared: HotKeyHandler!
    
    var hotKeyNotificationHandler = HotKeyNotificationHandler()
    
    var holdTimer: Timer?
    
    var isDown = false
    
    var delegate: HotKeyDelegate?
    
    init() {
        
        setHotkey(to: HLLDefaults.notifications.hotkey)
        
    }
    
    private var hotKey: HotKey? {
           didSet {
               
               guard let hotKey = hotKey else {
                   return
               }
               
               hotKey.keyDownHandler = {
                   
                self.isDown = true
     
                
              DispatchQueue.global(qos: .default).async {
                self.hotKeyNotificationHandler.hotKeyPressed()
                //self.delegate?.hotKeyDown()
               }
                   
               }
            
            hotKey.keyUpHandler = {
                
                self.isDown = false
                
                
            }
            
           }
           
       }
       
       var hotKeyState = HLLHotKeyOption.Off
       
      
    var settingHotKey = false
    
    func setHotkey(to: HLLHotKeyOption) {

        if to != hotKeyState, settingHotKey == false {
        settingHotKey = true
            
        switch to {
            
        case .Off:
            hotKey = nil
            hotKeyState = .Off
            print("Hot Key is now Off.")
        case .OptionW:
            hotKey = HotKey(key: .w, modifiers: [.option])
            print("Hot Key is now OptionW.")
            hotKeyState = .OptionW
        case .CommandT:
            hotKey = HotKey(key: .t, modifiers: [.command])
            print("Hot Key is now CommandT.")
            hotKeyState = .CommandT
        }
            
            settingHotKey = false
            
        }
        
    }
    
    
}

protocol HotKeyDelegate {
    
    func hotKeyDown()
    
}
