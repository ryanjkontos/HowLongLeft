//
//  OnboardingWindowManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit

class OnboardingWindowManager: NSObject, NSWindowDelegate {
    
    static var shared = OnboardingWindowManager()
    
    let onboardingStoryboard = NSStoryboard(name: "Onboarding", bundle: nil)
    var onboardingWindowController: NSWindowController?
    
    var delegate: OnboardingCompletionDelegate?
    
    func showOnboardingIfNeeded(delegate: OnboardingCompletionDelegate) {
           
        self.delegate = delegate
        
        onboardingWindowController?.window?.close()
        
    //    HLLDefaults.appData.launchedVersion = Version.currentVersion
            
        DispatchQueue.main.async {
        
            self.onboardingWindowController = self.onboardingStoryboard.instantiateController(withIdentifier: "Onboard1") as? NSWindowController
            self.onboardingWindowController!.window!.delegate = self
            self.onboardingWindowController!.window!.collectionBehavior = .canJoinAllSpaces
            self.onboardingWindowController!.window!.level = .floating
            NSApp.setActivationPolicy(.regular)
            self.onboardingWindowController!.showWindow(self)
            
        
        }
            
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        DispatchQueue.main.async {
        self.delegate?.onboardingComplete()
        }
        
        onboardingWindowController = nil
        return true
        
    }
    
    
}

protocol OnboardingCompletionDelegate {
    
    func onboardingComplete()
    
}
