//
//  PreferencesWindowManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit
import Preferences


class PreferencesWindowManager: NSObject, NSWindowDelegate, EventPoolUpdateObserver, HLLProStatusObserver {
    
    var preferencesWindowIsOpen: Bool {
        
        get {
            
            if let window = preferencesWindowController?.window {
                
                if window.isVisible {
                    return true
                }
                
            }
            
            return false
            
        }
        
    }
    
    var relalunchingWindow = false
    
    override init() {
        super.init()
        HLLEventSource.shared.addEventPoolObserver(self)
        ProStatusManager.shared.addStatusObserver(self)
        
    }
    
    func eventPoolUpdated() {


        
    }
    
    
    static var shared = PreferencesWindowManager()
    
    var preferencesWindowController: PreferencesWindowController?
    
    var currentIdentifier: Preferences.PaneIdentifier?


    @objc func objcLaunchPreferences() {
        
        launchPreferences()
        
    }
    
    func getPanes() -> [PreferencePane] {
        
        var viewControllers = [PreferencePane]()
            
            viewControllers.append(GeneralPreferenceViewController())
        
        if HLLEventSource.shared.access == CalendarAccessState.Denied {
                      viewControllers.append(CalendarPreferenceViewControllerNoAccess())
                  } else {
                      viewControllers.append(CalendarPreferenceViewController())
                  }
        
            viewControllers.append(StatusItemPreferenceViewController())
            
          
        if ProStatusManager.shared.isPro {
        
            viewControllers.append(CustomNotificationPreferencesViewController())
            
            if #available(OSX 11, *) {
            
                
            viewControllers.append(WidgetPreferenceViewController())
                
            }
            
            viewControllers.append(EventsPreferenceViewController())

            
        } else {
           viewControllers.append(NotificationPreferenceViewController())
            viewControllers.append(PurchaseProViewController())
        }
            

            
        return viewControllers
        
    }
    
    func launchPreferences(with ID: Preferences.PaneIdentifier? = nil, center: Bool = true) {
        
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        
        
        preferencesWindowController?.window?.close()
        
        
        
        preferencesWindowController = PreferencesWindowController(preferencePanes: getPanes())
        
        preferencesWindowController?.window?.delegate = self
        //preferencesWindowController?.window?.collectionBehavior = [.fullScreenAllowsTiling]
        
        preferencesWindowController?.window?.title = "How Long Left Preferences"
        
        NSApp.setActivationPolicy(.regular)
        
        preferencesWindowController?.show(preferencePane: ID)
        
       // WindowActivationWorkaround.shared.runWorkaroundFor(for: preferencesWindowController?.window)
        
        preferencesWindowController?.window?.makeKeyAndOrderFront(nil)
        
        if center {
        
        preferencesWindowController?.window?.center()
            
        }
        
        
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        if relalunchingWindow == false {
            preferencesWindowController?.window = nil
            preferencesWindowController = nil
        }
        
        relalunchingWindow = false
        
        return true
        
    }
    
   
    func proStatusChanged(from previousStatus: Bool, to newStatus: Bool) {
        
        
        if self.preferencesWindowIsOpen {
            
            if previousStatus == false {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                    self.launchPreferences(with: .general, center: false)
                    
                }
                
            }
            
            
        }
        
    }
    
    
        
    }
