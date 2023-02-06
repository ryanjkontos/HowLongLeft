//
//  SubjectSelectionWindowManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class SubjectSelectionWindowManager: NSObject, NSWindowDelegate {
    
    
    
    
    static var shared = SubjectSelectionWindowManager()
    
    let subjectSelectionStoryboard = NSStoryboard(name: "SubjectSelectionWindow", bundle: nil)
    var subjectSelectionWindowController: NSWindowController?
    
   
    
    func showSubjectSelection() {
        
        subjectSelectionWindowController?.window?.close()
 
        DispatchQueue.main.async {
        
            
            self.subjectSelectionWindowController = self.subjectSelectionStoryboard.instantiateController(withIdentifier: "SubjectSelectionWindowController") as? NSWindowController
            self.subjectSelectionWindowController!.window!.delegate = self
            self.subjectSelectionWindowController!.window!.collectionBehavior = .canJoinAllSpaces

            self.subjectSelectionWindowController!.window?.title = "How Long Left Pro"

            NSApp.setActivationPolicy(.regular)
            self.subjectSelectionWindowController!.showWindow(self)
            self.subjectSelectionWindowController!.window?.center()
            NSApp.activate(ignoringOtherApps: true)
            
        
        }
            
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
    
        subjectSelectionWindowController = nil
        return true
        
    }
    
    
}
