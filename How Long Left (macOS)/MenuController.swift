//
//  UIController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import AppKit
import HotKey
import Preferences

/*class MenuController: NSObject, NSMenuDelegate, NSWindowDelegate {
    
    static var shared: MenuController?

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let SIAttribute = [ NSAttributedString.Key.font: NSFont(name: "Helvetica Neue", size: 14.0)!]
    let basicIcon = NSImage(named: "statusIcon")!
    let colourIcon = NSImage(named: "ColourSI")!
    
    var useColour = true
    
    static var menuIsOpen = false
    var inNoAccessMode = false
    
    let version = Version()
    var topShelfItems = [NSMenuItem]()
    var doingStatusItemAlert = false
    var currentStatusItemText: String?
    var statusItemIsEmpty = false

    var statusItemUpdateHandler: StatusItemUpdateHandler!
    var menuUpdateHandler: MenuUpdateHandler!
    var hotKeyNotificationHandler = HotKeyNotificationHandler()
    let notificationScheduler = MacEventNotificationScheduler()
    let utilityRunLoopManager = UtilityRunLoopManager()
    
    let rnNeededEvaluator = RNNeededEvaluator()
    
    let mmsStoryboard = NSStoryboard(name: "MagdaleneModeSetupStoryboard", bundle: nil)
    
    var windowController: NSWindowController!
    
    override func awakeFromNib() {
        
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        
            NSApp.activate(ignoringOtherApps: true)
            
        self.windowController = self.mmsStoryboard.instantiateController(withIdentifier: "MagdaleneModeSetup") as? NSWindowController
            
            NSApp.setActivationPolicy(.regular)
          NSApp.activate(ignoringOtherApps: true)
            self.windowController.window?.delegate = self
            self.windowController.window?.level = .normal
            self.windowController.window?.collectionBehavior = [.fullScreenNone, .fullScreenDisallowsTiling]
            self.windowController.showWindow(self)
            
            self.windowController.window?.center()
            NSApp.activate(ignoringOtherApps: true)
            
            
        }*/
        
        LaunchFunctions.shared.runLaunchFunctions()
        
        MagdaleneModeSetupPresentationManager.shared = MagdaleneModeSetupPresentationManager()
        
        HLLEventSource.shared.updateEventPool()
        MenuController.shared = self
          
        windowMenu.delegate = self
        
        self.statusItem.button?.imagePosition = .imageLeft

        let currentVersion = Version.currentVersion
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
          
              if #available(OSX 10.14, *) {
              
                  self.statusItem.button?.image = self.icon
              
              } else {
                  
                  self.statusItem.image = self.icon
                  
              }
            
            self.appInfoRow.title = "How Long Left \(currentVersion) (\(build!))"
            self.statusItem.menu = self.mainMenu
            self.icon.isTemplate = self.SITemplate
            self.mainMenu.removeItem(at: 0)
            self.mainMenu.delegate = self as NSMenuDelegate
            
        
          
      }
  
   
    
    func menuDidClose(_ menu: NSMenu) {

        if menu == mainMenu {
          
            MenuController.menuIsOpen = false
            self.statusItem.button?.highlight(false)
            
        }
        
    }
    
    
    @IBAction func clearSelected(_ sender: NSMenuItem) {
        
        SelectedEventManager.shared.selectedEvent = nil
        
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        
        if menu == mainMenu {
            
            let startDate = Date()
                  
                  self.statusItem.button?.highlight(true)
                  MenuController.menuIsOpen = true
            
           MenuController.menuIsOpen = true
            
            menuUpdateHandler.updateAppMenu()
            
          
            
            let key = "ShownSelectionTip"
            
            
            if HLLDefaults.defaults.bool(forKey: key) {
                
                selectionTipMenuItem.isHidden = true
                
            } else {
                
                HLLDefaults.defaults.set(true, forKey: key)
                selectionTipMenuItem.isHidden = false
                
            }
            
            if SchoolAnalyser.schoolMode == .Magdalene, HLLDefaults.magdalene.showCompassButton == true {
                
                openCompassButton.isHidden = false
                
                
            } else {
                
                openCompassButton.isHidden = true
                
            }
            
            if NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option) {
                
                appInfoRow.isHidden = false
                
            } else {
                
                appInfoRow.isHidden = true
            }
            
            if HLLEventSource.accessToCalendar == .Denied {
            
                noCalAccessInfo.isHidden = false
                noCalAccessButton.isHidden = false
                
            } else {
                
                noCalAccessInfo.isHidden = true
                noCalAccessButton.isHidden = true
                
            }
            
            
            if HLLDefaults.general.showUpdates == false {
                
                updateAvaliableItem.isHidden = true
                
            }
            
            let endDate = Date()

            DispatchQueue.main.async {
                print("Menu took \(endDate.timeIntervalSince(startDate)) to open.")
            }


        }
        
        if menu == windowMenu {
            
            print("Window menu opening")
            
            if let frontWindow = NSApp.keyWindow {
            
                if let _ = frontWindow.contentViewController!.children.first!.self as? EventUITabViewController {
                    
                    floatCountdownWindowButton.isHidden = false
                    
                    if frontWindow.level == .statusBar {
                        floatCountdownWindowButton.state = .on
                        
                    } else {
                        floatCountdownWindowButton.state = .off
                    }
                    
                } else {
                    
                    floatCountdownWindowButton.isHidden = true
                    
                }
                
            }
            
        }
   
    }
    
    @IBAction func floatCountdownWindowClicked(_ sender: NSMenuItem) {
        
        
        if let frontWindow = NSApp.keyWindow {
        
            if let _ = frontWindow.contentViewController!.children.first!.self as? EventUITabViewController {
                
               
                if frontWindow.level == .statusBar {
                    
                    frontWindow.level = .normal
                    
                } else {
                    
                    frontWindow.level = .statusBar
                    
                }
                
                
            }
            
        }
        
        
    }
    func setTopShelfItems(_ items: [NSMenuItem]) {
        
        for menuItem in topShelfItems {
            self.mainMenu.removeItem(menuItem)
        }
        
        topShelfItems.removeAll()
        
        if HLLEventSource.shared.access == .Denied {
            return
        }
        
        for menuItem in items.reversed() {
        topShelfItems.append(menuItem)
        self.mainMenu.insertItem(menuItem, at: 0)
        }
        
    }
 
    func updateSchoolEventChangesMenuItem(with item: NSMenuItem?) {
        
        if SchoolAnalyser.schoolMode != .Magdalene {
            schoolEventChangesMenuItem.isHidden = true
        }
        
        if let safeItem = item {
        
            schoolEventChangesMenuItem.isHidden = false
            schoolEventChangesMenuItem.title = safeItem.title
            schoolEventChangesMenuItem.submenu = safeItem.submenu
            schoolEventChangesMenuItem.isEnabled = safeItem.isEnabled
            schoolEventChangesMenuItem.state = safeItem.state
            
        } else {
            
            schoolEventChangesMenuItem.isHidden = true
            
        }
    }
    
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
    
    
    @IBAction func compassButtonClicked(_ sender: NSMenuItem) {
        
        openCompass()
    }
    
    func openCompass() {
        
        if let url = URL(string: "https://mchsdow-nsw.compass.education/Organise/Calendar/") {
            NSWorkspace.shared.open(url)
            print("Compass was successfully opened")
        }
        
        
    }
    
    
    var currentAlertRequestDate = Date()
    
    func doStatusItemAlert(with strings: [String], showEachItemFor: Double = 1.5) {
        
        // Set how long each text item should show.
        let requestDate = Date()
        currentAlertRequestDate = requestDate
        
        
        if HLLDefaults.statusItem.mode != .Off {
        
        DispatchQueue.main.async {
            
            self.doingStatusItemAlert = true
            let items = strings
    
            var scheduledCycle = 0.0
                
                for item in items {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + scheduledCycle) {
                        
                        if requestDate == self.currentAlertRequestDate {
                        
                        let attributedString = NSAttributedString(string: item, attributes: self.SIAttribute)
                        
                            if #available(OSX 10.14, *) {
                                
                                self.statusItem.button?.image = nil
                                self.statusItem.button?.isTransparent = self.SITemplate
                                self.statusItem.button?.attributedTitle = attributedString
                                
                            } else {
                                
                                self.statusItem.image = nil
                                self.icon.isTemplate = self.SITemplate
                                self.statusItem.attributedTitle = attributedString
                                
                            }
                            
                        }
                    }
                    
                    scheduledCycle += showEachItemFor
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + scheduledCycle) {
                    self.doingStatusItemAlert = false
                }
                
            }
            
            }
        }
    
    func noCalendarAccessUIState(enabled: Bool) {
        
      //  nextEventRow.isHidden = enabled
       // upcomingEventsRow.isHidden = enabled
      
        
    }
    
    
    @IBAction func fixClicked(_ sender: NSMenuItem) {
        
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"),
            
            NSWorkspace.shared.open(url) {
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSWorkspace.shared.launchApplication("System Preferences")
        }
        
    }
    
    func setUpdateAvaliableState(version: String?) {
        
       
    }
    
    @IBAction func updateAvaliableClicked(_ sender: NSMenuItem) {
        
        if let url = URL(string: "macappstore://showUpdatesPage") {
            NSWorkspace.shared.open(url)
            print("default browser was successfully opened")
        }
    }
    
    static var preferencesWindowController: PreferencesWindowController?
    
    @IBAction func preferencesButtonClicked(_ sender: NSMenuItem) {
        
        PreferencesWindowManager.shared.launchPreferences()
        
    }
    
    var vcs = [PreferencePane]()
    
   
    
    @IBAction func aboutClicked(_ sender: NSMenuItem) {
        PreferencesWindowManager.shared.launchPreferences()
    }
    
    
    @IBAction func quitClicked(_ sender:
        NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
        
    private var hotKey: HotKey? {
         didSet {
             
             guard let hotKey = hotKey else {
                 return
             }
             
             hotKey.keyDownHandler = {
                 
            DispatchQueue.global(qos: .default).async {
                self.hotKeyNotificationHandler.hotKeyPressed()
             }
                 
             }
         }
         
     }
     
     var hotKeyState = HLLHotKeyOption.Off
     
    
     
    var icon: NSImage {
        
        get {
            
            if HLLDefaults.statusItem.appIconStatusItem {
                
                return colourIcon
                
            } else {
                
                return basicIcon
                
            }
            
            
        }
        
        
    }
    
    var SITemplate: Bool {
        
        get {
            
            if HLLDefaults.statusItem.appIconStatusItem {
                
                return false
                
            } else {
                
                return true
                
            }
            
            
        }
        
        
    }

}
*/
