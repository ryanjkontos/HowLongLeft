//
//  MagdaleneModeSetupPresentationManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 24/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
/*
class MagdaleneModeSetupPresentationManager: NSObject, NSWindowDelegate, EventPoolUpdateObserver {
    
    static var shared: MagdaleneModeSetupPresentationManager!
    
    var hasPresented = false
    
    var allowAutomaticPresentation = false
    
   
    let mmsStoryboard = NSStoryboard(name: "MagdaleneModeSetupStoryboard", bundle: nil)
    var mmsWindowController: NSWindowController?
    
    override init() {
        super.init()
        HLLEventSource.shared.addEventPoolObserver(self)
        
    }
    
    func presentMagdaleneModeSetupIfNeeded() {
        
        if !allowAutomaticPresentation {
            return
        }
        
        if HLLDefaults.magdalene.promptToSetUp == false {
            return
        }
        
        if self.hasPresented {
            return
        }
        
        let state = schoolEventDownloadNeededEvaluator.evaluateSchoolEventDownloadNeeded()
        
        if state != .notNeeded {
            
            presentMagdaleneModeSetup(with: state)
            
        }
        
    }
    
    func presentMagdaleneModeSetup(with state: SchoolEventDownloadNeededStatus) {
        
        self.hasPresented = true
        
        
        DispatchQueue.main.async {
            
            if self.mmsWindowController?.window == nil {
            
               
                
                autoreleasepool {
                
                self.mmsWindowController = self.mmsStoryboard.instantiateController(withIdentifier: "MagdaleneModeSetup") as? NSWindowController
            self.mmsWindowController?.window?.contentViewController?.children.first?.representedObject = state
                    
                    if self.schoolEventDownloadNeededEvaluator.evaluateSchoolEventDownloadNeeded() == .notNeeded {
                        (self.mmsWindowController?.window?.contentViewController?.children.first as? ControllableTabView)?.goToIndex(2)
                    }
                    
                
                self.mmsWindowController?.window?.delegate = self
                self.mmsWindowController?.window?.level = .normal
                self.mmsWindowController?.window?.collectionBehavior = [.fullScreenNone, .fullScreenDisallowsTiling]
                self.mmsWindowController?.window?.center()
                
                    
                }
            
            }
            
        }
        
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        mmsWindowController?.window?.contentViewController = nil
        mmsWindowController?.window = nil
        mmsWindowController = nil
        return true
        
    }
    
    func eventPoolUpdated() {
        presentMagdaleneModeSetupIfNeeded()
    }
    
}
*/
