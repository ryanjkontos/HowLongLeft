//
//  RNUI Manager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class RNUIManager: NSObject, NSWindowDelegate {

    static var shared = RNUIManager()
    
    var renameWindowController : NSWindowController?
    var renameStoryboard = NSStoryboard()
    var promptedToRename = false
    
    func promptToRenameIfNeeded() {
        
        if HLLDefaults.rename.promptToRename, promptedToRename == false {
            
            promptedToRename = true
            present()
 
        }
        
    }
    
    func present() {
        
        DispatchQueue.main.async { [unowned self] in
            
      //  NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
           
            if self.renameWindowController == nil {
            
            self.renameStoryboard = NSStoryboard(name: "RNUI", bundle: nil)
            self.renameWindowController = self.renameStoryboard.instantiateController(withIdentifier: "Rename1") as? NSWindowController
                
            }
            
            NSApp.activate(ignoringOtherApps: true)
            self.renameWindowController?.window!.makeMain()
            self.renameWindowController?.window!.makeKey()
            self.renameWindowController!.window!.delegate = self
            self.renameWindowController!.showWindow(self)
            self.renameWindowController!.window!.center()
            
            // print("Can be key \(self.renameWindowController!.window!.canBecomeKey)")
            // print("Can be main \(self.renameWindowController!.window!.canBecomeMain)")
            
        }
        
    }
    
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        if sender == renameWindowController?.window {
            
            renameWindowController = nil
            
        }
        
        return true
        
    }
    
    
}

class windowC: NSWindowController {

    
    override func windowDidLoad() {
        
       // NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        self.window!.makeMain()
        self.window!.makeKey()
        self.window!.makeKeyAndOrderFront(self)
    }
    
    
    
    
}

class aWindow: NSWindow {
    
    override var canBecomeMain: Bool {
        
        return true
        
    }
    
    override var canBecomeKey: Bool {
        
        return true
        
    }
    
    
}
