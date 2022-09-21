//
//  StatusItemController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

/*class StatusItemController: NSObject, NSMenuDelegate {
    
    var statusItemTextHander: HLLStatusItemContentGenerator!
    var menuUpdateHandler = MainMenuGenerator()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let SIAttribute = [ NSAttributedString.Key.font: NSFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)]
    let basicIcon = NSImage(named: "statusIcon")!
    let colourIcon = NSImage(named: "ColourSI")!
    var doingStatusItemAlert = false
    var currentStatusItemText: String?
    var statusItemIsEmpty = false
    var statusItemText = ""
    var menu = NSMenu()
    
    var mainMenu: NSMenu?
    
    var timer: Timer!
    
    var mainMenuIsOpen = false
    
    var icon: NSImage {
        get {
            if HLLDefaults.statusItem.appIconStatusItem {
                return colourIcon
            } else {
                return basicIcon
            }
           }
       }
       
       var statusItemImageIsTemplate: Bool {
        get {
            if HLLDefaults.statusItem.appIconStatusItem {
                return false
            } else {
                return true
            }
           }
       }
    
    override init() {
      
        super.init()
        
        self.statusItem.button?.imagePosition = .imageOnly
        let setIcon = icon
        setIcon.isTemplate = statusItemImageIsTemplate
        self.statusItem.image = setIcon
        self.statusItem.button?.setupPasteboard()
        self.statusItem.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])
        self.statusItem.target = self
        self.statusItem.button?.action = #selector(statusItemClicked)
        
        menu.delegate = self
        
       // self.statusItem.menu = menu
        
        self.icon.isTemplate = self.statusItemImageIsTemplate
        updateStatusItem(with: nil)

            
        self.statusItemTextHander = HLLStatusItemContentGenerator(delegate: self)
        
        
        
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        
        self.statusItem.button?.isHighlighted = true
        mainMenu = menu
        generateMenu(menu)
        mainMenuIsOpen = true
        
        
    }
    
    func menuDidClose(_ menu: NSMenu) {
        mainMenuIsOpen = false
        self.statusItem.button?.isHighlighted = false
    }
    
    
    
    @objc func statusItemClicked() {
        
        let event = NSApp.currentEvent!

        if event.type == .leftMouseDown {
            self.statusItem.popUpMenu(menu)
            self.statusItem.button?.isHighlighted = true
        }
        
        if event.type == .rightMouseDown {
            self.statusItem.button?.isHighlighted = true
        }
        
        if event.type == .rightMouseUp {
            self.statusItem.button?.isHighlighted = false
            SelectedEventManager.shared.selectedEvent = nil
            print("okay sure m89")
                self.statusItemTextHander.updateStatusItem()
        }
        
    }
    
    func generateMenu(_ menu: NSMenu) {
        
        let items = self.menuUpdateHandler.getMainMenu()
        menu.removeAllItems()
        
        for item in items {
            menu.addItem(item)
        }
        
    }
    
    func updateStatusItem(with text: String?, selected: Bool = false) {
        
        if self.doingStatusItemAlert == false {
        
           
            
        if let unwrappedText = text, HLLDefaults.statusItem.mode != .Off {
             
            
            if unwrappedText == statusItemText {
                return
            }
            
            self.statusItemText = unwrappedText
            
                DispatchQueue.main.async {
                    
                    [unowned self] in
                    
                    self.statusItem.button?.alphaValue = 1
                    
                    
                    
                    self.statusItem.button?.imagePosition = .imageLeading
                    
                    if selected {
                        
                        if #available(OSX 10.14, *) {
                        
                            self.statusItem.button?.image = NSImage(named: NSImage.menuOnStateTemplateName)
                            
                        } else {
                            
                            self.statusItem.image = NSImage(named: NSImage.menuOnStateTemplateName)
                            
                            
                        }
                        
                        self.icon.isTemplate = true
                        
                    } else {
                        
                        if #available(OSX 10.14, *) {
                        
                            self.statusItem.button?.image = nil
                            
                        } else {
                            
                            self.statusItem.image = nil
                            
                        }
                        self.icon.isTemplate = self.statusItemImageIsTemplate
                        
                    }
                    
                if #available(OSX 10.14, *) {
                
                    self.statusItem.button?.attributedTitle = NSAttributedString(string: unwrappedText, attributes: self.SIAttribute)
                
                } else {
                    
                    self.statusItem.attributedTitle = NSAttributedString(string: unwrappedText, attributes: self.SIAttribute)

                }
                    
                    self.currentStatusItemText = unwrappedText
                    self.statusItemIsEmpty = false
                    
                }
        
        } else {
            
            statusItemText = ""
                
            
            DispatchQueue.main.async {
            
                  [unowned self] in
                
                if HLLDefaults.statusItem.inactive {
                    self.statusItem.button?.alphaValue = 0.5
                } else {
                    self.statusItem.button?.alphaValue = 1.0
                }
                
              
                
            if #available(OSX 10.14, *) {
                
                if self.statusItem.button?.title != nil {
            
                self.statusItem.button?.imagePosition = .imageOnly
                self.statusItemIsEmpty = true
                self.statusItem.button?.title = ""
                self.statusItem.button?.image = self.icon
                self.icon.isTemplate = self.statusItemImageIsTemplate
                
            }
                
        } else {
                
            if self.statusItem.title != nil {
                
                self.statusItem.button?.imagePosition = .imageOnly
                self.statusItemIsEmpty = true
                self.statusItem.attributedTitle = nil
                self.statusItem.image = self.icon
                self.icon.isTemplate = self.statusItemImageIsTemplate
                    
        }
                
        }
                
            }
            
            
            
        }
        
    }
            
    }
    
    @objc func updateMenu() {
        
        DispatchQueue.main.async {
        
        if let main = self.mainMenu {
            self.generateMenu(main)
        }
            
        }
        
    }
    
}


extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
} */

