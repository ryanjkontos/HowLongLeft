//
//  ProOnboardingWindowManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class ProOnboardingWindowManager: NSObject, NSWindowDelegate, ProPriceDelegate, HLLProStatusObserver {
    
    
    func proPriceUpdated() {
        
        if ProPurchaseHandler.shared.proPrice != nil {
            
            gotPrice = true
            self.showProOnboarding()
        }
        
    }
    
    func onboardingComplete() {
        
        requestedByProOnboarding = true
        self.showProOnboarding()
    }
    
    var requestedByProOnboarding = false
    var gotPrice = false
    
    var shown = false
    
    static var shared = ProOnboardingWindowManager()
    
    let proOnboardingStoryboard = NSStoryboard(name: "ProOnboarding", bundle: nil)
    var proOnboardingWindowController: NSWindowController?
    
    override init() {
           super.init()
           
     //   // print("Init PWM")
        ProPurchaseHandler.shared.addPriceDelegate(self)
        ProStatusManager.shared.addStatusObserver(self)
           
       }
    
    func showProOnboarding() {
        
     if ProStatusManager.shared.isPro == true {
            return
        }
         
        if shown {
             return
         }
  
         self.shown = true
        
       if HLLDefaults.defaults.bool(forKey: "ShownProPrompt") == true {
            return
        }
        
        if let controller = proOnboardingWindowController, let window = controller.window, window.isVisible {
            return
        }
        
        if requestedByProOnboarding == false {
            return
        }
        
        if gotPrice == false {
            return
        }
        
       
        
        HLLDefaults.defaults.set(true, forKey: "ShownProPrompt")
        
        DispatchQueue.main.async {
        
            
            self.proOnboardingWindowController = self.proOnboardingStoryboard.instantiateController(withIdentifier: "ProOnboardingWindowController") as? NSWindowController
            self.proOnboardingWindowController!.window!.delegate = self
            self.proOnboardingWindowController!.window!.collectionBehavior = .canJoinAllSpaces
            //self.proOnboardingWindowController!.window?.titlebarAppearsTransparent = true
            self.proOnboardingWindowController!.window?.title = "How Long Left Pro"
            //self.proOnboardingWindowController!.window?.titleVisibility = .hidden
            //self.proOnboardingWindowController!.window?.styleMask = [.fullSizeContentView]
            NSApp.setActivationPolicy(.regular)
            self.proOnboardingWindowController!.showWindow(self)
            self.proOnboardingWindowController!.window?.center()
            NSApp.activate(ignoringOtherApps: true)
            
            
        
        }
            
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
    
        proOnboardingWindowController = nil
        return true
        
    }
    
    func proStatusChanged(from previousStatus: Bool, to newStatus: Bool) {
        
        if newStatus == true {
            self.proOnboardingWindowController?.window?.close()
            
        }
        
    }
    
    
}
