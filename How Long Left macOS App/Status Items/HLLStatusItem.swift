import Foundation
import Cocoa
import SwiftUI

class HLLStatusItem {
    
    let uuid = UUID()
    var statusItem: NSStatusItem? = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var image = StatusItemGlobals.basicIcon
    var currentText: String?

    let configuration: HLLStatusItemConfiguration!
    var statusItemTextHander: HLLStatusItemContentGenerator?
    let menuDelegate = HLLStatusItemMenuDelegate()
    var menuGenerator: StatusItemMenuGenerator!
    
    var doingStatusItemAlert = false
    var currentStatusItemText: String?
    var statusItemIsEmpty = false
    var statusItemText = ""
    
    var override = false
    
    var menu = NSMenu()
    var contentGen: HLLStatusItemContentGenerator
       
    var currentContent: HLLStatusItemContent?
    
    var latestRetreivedEvent: HLLEvent?
    
    var mainMenu: NSMenu?
       
       
       var mainMenuIsOpen = false
       
       
    init(configuration: HLLStatusItemConfiguration) {
         
      //  // print("Creating status item with config: \(configuration)")
    
        
        self.configuration = configuration
        
        self.contentGen = HLLStatusItemContentGenerator(configuration: configuration)
        
        if configuration.type == .event {
            self.statusItem?.autosaveName = self.configuration.eventRetriver.retrieveEvent()?.persistentIdentifier
        } else {
            self.statusItem?.autosaveName = "Main"
        }

       
        self.statusItem?.isVisible = true
        self.statusItem?.button?.imagePosition = .imageOnly
     //   self.statusItem?.image = StatusItemGlobals.basicIcon
        
        updateContent()
        
   
        
        self.menuGenerator = StatusItemMenuGenerator()
            
            self.updateDragMode()
        self.statusItem?.button?.sendAction(on: [.leftMouseDown, .rightMouseUp])
        self.statusItem?.target = self
           self.statusItem?.button?.action = #selector(self.statusItemClicked(_:))
        self.menuDelegate.delegate = self
            self.menu.delegate = self.menuDelegate
        
  
          
                    
            // StatusItem is stored as a class property.
           
            self.statusItem?.menu = self.menu
            
            let item = self.statusItem!

            
        switch configuration.type {
            
            
        case .main:
            self.statusItem?.behavior = .terminationOnRemoval
        case .event:
            self.statusItem?.behavior = .removalAllowed
        }
        
           /* let view = NSHostingView(rootView: StatusItemView().padding(.horizontal, 10).fixedSize())
                    item.button?.addSubview(view)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        view.leadingAnchor.constraint(equalTo: item.button!.leadingAnchor),
                        view.trailingAnchor.constraint(equalTo: item.button!.trailingAnchor),
                        view.heightAnchor.constraint(equalToConstant: 20),
                        view.centerYAnchor.constraint(equalTo: item.button!.centerYAnchor)
                    ]) */
            
        updateContent()
        
           
       }
       
       func menuWillOpen(_ menu: NSMenu) {
           
        self.statusItem?.button?.isHighlighted = true
           mainMenu = menu
           generateMenu(menu)
           mainMenuIsOpen = true
           
           
       }
       
       func menuDidClose(_ menu: NSMenu) {
           mainMenuIsOpen = false
        self.statusItem?.button?.isHighlighted = false
       }
       
    @objc func statusItemClicked(_ sender: Any?) {
           
           let event = NSApp.currentEvent!

           if event.type == .leftMouseDown {
         
            
            self.statusItem?.popUpMenu(menu)
            self.statusItem?.button?.isHighlighted = true
           }
           
        
        if ProStatusManager.shared.isPro {
        
           if event.type == .rightMouseDown {
            self.statusItem?.button?.isHighlighted = true
           }
           
           if event.type == .rightMouseUp {
            self.statusItem?.button?.isHighlighted = false
               
            if SelectedEventManager.shared.selectedEvent != nil {
                SelectedEventManager.shared.selectedEvent = nil
            } else {
                
                if HLLDefaults.statusItem.mode == .Off {
                    HLLDefaults.statusItem.mode = HLLDefaults.statusItem.mostRecentEnabledMode
                } else {
                    
                    let noto = HLLNotificationContent(date: Date())
                    noto.title = "How Long Left is now inactive"
                    noto.subtitle = "You can two-finger click the status item to reactivate."
                    
                    MacNotificationDeliveryHandler.shared.deliver(noto)
                    HLLDefaults.statusItem.mode = .Off
                }
                
            }
            

           }
        
    }
           
       }
       
       func generateMenu(_ menu: NSMenu) {
           
      let items = self.menuGenerator.getStatusItemMenu(for: self.configuration)
           menu.removeAllItems()
           
        
        
        
           for item in items {
         
               menu.addItem(item)
           }
    
           
       }
       
       
       
       @objc func updateMenu() {
           
           DispatchQueue.main.async {
           
           if let main = self.mainMenu {
               self.generateMenu(main)
           }
               
           }
           
       }

    func remove() {
      
        // print("Removing status item")
        
        self.statusItem = nil
        self.statusItemTextHander = nil
        
    }
    
 
    func updateContent() {
        
        let content = self.contentGen.getStatusItemContent()
        
        if let currentContent = currentContent {
            if currentContent == content {
                return
            }
        }
        
        setStatusItemContent(content)
        
    }

    private func setStatusItemContent(_ content: HLLStatusItemContent, force: Bool = false) {
        
        //
        
       if override {
            if !force {
               return
            }
        }
        

            
            
            self.update()
            
        if let text = content.text {
            self.statusItem?.button?.attributedTitle = NSAttributedString(string: text, attributes: StatusItemGlobals.textAttribute)
        }
        
        if let image = content.image {
        
            self.statusItem?.button?.image = image
            var imagePosition = NSControl.ImagePosition.imageLeading
            if content.text == nil { imagePosition = .imageOnly }
            self.statusItem?.button?.imagePosition = imagePosition

        } else {
           self.statusItem?.button?.image = nil
        }
        
        self.statusItem?.button?.alphaValue = content.alpha
            
            self.currentContent = content
            
        
        
        
    }
    
    func update() {
        
        
        if let item = statusItem {
            
            if item.isVisible == false {
                
                
                if let event = self.configuration.eventRetriver.retrieveEvent() {
                    latestRetreivedEvent = event
                    if self.configuration.type == .event {
                        HLLStatusItemManager.shared.removeEventStatusItem(with: event)
                    }
                    
                    
                } else {
                    latestRetreivedEvent = nil
                }
                
            }
            
        }
        
    
        
    }
    
    func updateDragMode() {
        
        if self.configuration.type == .main {
               
            self.statusItem?.button?.setupPasteboard()
                   
        }
        
    }
    
    deinit {
        // print("Deiniting a status item!!")
        self.statusItem = nil
    }
    
    
}

/*extension HLLStatusItem: HLLProStatusObserver {
    
    func proStatusChanged(from previousStatus: Bool, to newStatus: Bool) {
        
        if newStatus, !previousStatus {
            
            override = true
            
            var content = HLLStatusItemContent()
            content.text = "Pro Mode Enabled"
            content.alpha = StatusItemGlobals.inactiveAlpha
            
            setStatusItemContent(content, force: true)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                self.override = false
                self.updateContent()
                
            }
            
        }
        
    }
    
} */

class HLLStatusItemMenuDelegate: NSObject, NSMenuDelegate {
    
    var delegate: HLLStatusItem!
    
    func menuWillOpen(_ menu: NSMenu) {
        delegate.menuWillOpen(menu)
    }
    
    func menuDidClose(_ menu: NSMenu) {
        delegate.menuDidClose(menu)
    }
    
}
