//
//  StatusItemPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import Preferences
import LaunchAtLogin
import EventKit

final class StatusItemPreferenceViewController: NSViewController, PreferencePane, NSTextFieldDelegate {
	
	
	
	@IBOutlet weak var tabView: NSTabView!
	let preferencePaneIdentifier = Preferences.PaneIdentifier.statusItem
    var preferencePaneTitle: String = "Status Item"
	
	let toolbarItemIcon = PreferencesGlobals.statusItemImage
    
    override var nibName: NSNib.Name? {
        return "StatusItemPreferencesView"
    }
    
	@IBOutlet weak var configLabel: NSTextField!
	@IBOutlet weak var configButton: NSPopUpButton!
	@IBOutlet weak var modeSegmented: NSSegmentedControl!
	@IBOutlet weak var statusItemPreviewText: NSTextField!

	
	@IBOutlet weak var modeRadio_Off: NSButton!
    @IBOutlet weak var modeRadio_Timer: NSButton!
    @IBOutlet weak var modeRadio_Minute: NSButton!
    
    @IBOutlet weak var showTitleCheckbox: NSButton!
    @IBOutlet weak var showLeftTextCheckbox: NSButton!
    @IBOutlet weak var showPercentageCheckbox: NSButton!
	@IBOutlet weak var showEndTimeCheckbox: NSButton!

    
    @IBOutlet weak var previewIcon: NSImageView!
    @IBOutlet weak var unitsMenu: NSPopUpButton!
	@IBOutlet weak var previewTypeSegment: NSSegmentedControl!
	
	var desArray = [NSTextField]()
	
    let shortUnitsMenuItemText = "Use short units (h, min)"
    let fullUnitsMenuItemText = "Use full units (hours, minutes)"
    
    let timerFullText = "Include seconds"
	let timerShortText = "Don't include seconds"
	
	let formatter = NumberFormatter()
	
	var timer: Timer?

	@IBOutlet weak var limitTitleLengthButton: NSButton!
	
	@IBOutlet weak var limitTitleLengthBox: NSTextField!
	@IBOutlet weak var limitTitleLengthStepper: NSStepper!
	
	
	let preferSoonestText = "Current & Upcoming (Prefer Soonest)"
	let preferCurrentText = "Current & Upcoming (Prefer Current)"
	
	let onlyCurrentText = "Only Current Events"
	let onlyUpcomingText = "Only Upcoming Events"
	
	let onlySelected = "Only Selected Events"

	
	var previewEvent: HLLEvent?
	
	override func viewWillAppear() {
        
		formatter.allowsFloats = false
		limitTitleLengthBox.formatter = formatter
		
	
		
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
		updateTextBoxValue()
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.preferredContentSize = CGSize(width: 451, height: 456)

		updateUnitsMenu(enabled: HLLDefaults.statusItem.mode == .Minute)
		
		let menu = NSMenu()
		
		menu.addItem(NSMenuItem.makeItem(title: self.preferSoonestText))
		menu.addItem(NSMenuItem.makeItem(title: self.preferCurrentText))
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem.makeItem(title: self.onlyCurrentText))
		menu.addItem(NSMenuItem.makeItem(title: self.onlyUpcomingText))
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem.makeItem(title: self.onlySelected))
		
		configButton.menu = menu
		
		let type = HLLDefaults.statusItem.eventMode
		
		configButton.selectItem(withTitle: getString(from: type))
		
		timer = Timer(timeInterval: 0.2, target: self, selector: #selector(generateStatusItemPreview), userInfo: nil, repeats: true)
			RunLoop.main.add(timer!, forMode: .common)
		

		
		desArray = [des1, des2, des3, des4]
		
		limitTitleLengthBox.stringValue = String(HLLDefaults.statusItem.statusItemTitleLimit)
		
		previewIcon.alphaValue = 1.0
		//	previewIcon.contentTintColo
		
		switch HLLDefaults.statusItem.mode {
			
		case .Off:
			modeSegmented.selectedSegment = 0
		case .Timer:
			modeSegmented.selectedSegment = 1
		case .Minute:
			modeSegmented.selectedSegment = 2
		}
		
		limitTitleLengthButton.state = HLLDefaults.statusItem.limitStatusItemTitle.controlStateValue
		
		adaptForMode(HLLDefaults.statusItem.mode)
		
		
		
		var SITitleState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showTitle == true { SITitleState = .on }
		showTitleCheckbox.state = SITitleState
		
		var SILeftState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showLeftText == true { SILeftState = .on }
		showLeftTextCheckbox.state = SILeftState
		
		previewIcon.image = NSImage(named: "MenuSI")
		
		
		var SIPercentageState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showPercentage == true { SIPercentageState = .on }
		showPercentageCheckbox.state = SIPercentageState
		
		var SIEndState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showEndTime == true { SIEndState = .on }
		showEndTimeCheckbox.state = SIEndState
		
		// Setup stuff here
		
		previewEvent = createPreviewEvent()
		
		statusItemPreviewText.font = NSFont.monospacedDigitSystemFont(ofSize: statusItemPreviewText.font!.pointSize, weight: .medium)
		
		self.generateStatusItemPreview()
		
	}
	
	@IBAction func eventConfigClicked(_ sender: NSPopUpButton) {
		
		if let title = sender.selectedItem?.title, let type = getEventMode(from: title) {
			
			HLLDefaults.statusItem.eventMode = type
			
		}
		
		
		
	}
	
	
	func createPreviewEvent() -> HLLEvent {

		
		return HLLEvent(title: "Event", start: CurrentDateFetcher.currentDate.addingTimeInterval(-1), end: CurrentDateFetcher.currentDate.addingTimeInterval(5400), location: nil)
			
		
		
	}
	
	
	@IBAction func eventPreviewTypeSegementChanged(_ sender: NSSegmentedControl) {
		
		previewEvent = nil
		generateStatusItemPreview()
		
	}
	
	
    @IBAction func modeSegmentChanged(_ sender: NSSegmentedControl) {
		
		DispatchQueue.main.async {
			
			var value = 0
			
			if sender.selectedSegment == 0 {
				
				value = 2
				
			}
			
			if sender.selectedSegment == 1 {
				
				value = 0
				
			}
			
			if sender.selectedSegment == 2 {
				
				value = 1
				
			}
			
			
			
		
        if let mode = StatusItemMode(rawValue: value) {
            
            HLLDefaults.statusItem.mode = mode
			
			self.adaptForMode(mode)
        
			self.generateStatusItemPreview()
			
		}
			
			self.updateUnitsMenu(enabled: HLLDefaults.statusItem.mode == .Minute)
			
			HLLStatusItemManager.shared.updateAll()
        
    }
		
	}
	
	@IBAction func includeCurrentClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showCurrent = state
			
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
	}
	
	@IBAction func includeUpcomingClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showUpcoming = state
			
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
		
	}
	
	@IBAction func imageButtonClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var image = NSImage(named: "logo")
			
			var state = false
			if sender.state == .on { state = true
				
				image = NSImage(named: "MenuSI")
				
			}
			
			self.previewIcon.image = image
			
			HLLDefaults.statusItem.appIconStatusItem = !state
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
			
			
		}
		
		
	}
	
    @IBAction func showTitleClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showTitle = state
			
			self.adaptForMode(HLLDefaults.statusItem.mode)
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
        
    }
	
    
    @IBAction func showLeftText(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showLeftText = state
        
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
		}
        
    }
    
	@IBAction func showEndTimeClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showEndTime = state
			
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
		}
		
		
	}
	
    @IBAction func showPercentageClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showPercentage = state
        
			self.generateStatusItemPreview()
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
        
    }
    
    @IBAction func unitsClicked(_ sender: NSPopUpButton) {
		
		DispatchQueue.main.async {
		
			// print("Units clicked: \(sender.selectedItem!.title)")
			
		let title = sender.selectedItem!.title
			
			if title == self.fullUnitsMenuItemText {
				// print("Use full units")
				HLLDefaults.statusItem.useFullUnits = true
			}
			
			if title == self.shortUnitsMenuItemText {
				// print("Don't use full units")
				HLLDefaults.statusItem.useFullUnits = false
			}
	
			if title == self.timerShortText {
				// print("Don't show seconds")
				HLLDefaults.statusItem.hideTimerSeconds = true
			}
		
			if title == self.timerFullText {
				// print("Show seconds")
				HLLDefaults.statusItem.hideTimerSeconds = false
			}
			
			
        
			self.generateStatusItemPreview()
			HLLStatusItemManager.shared.updateAll()
			
		}
        
    }

	func adaptForMode(_ mode: StatusItemMode) {
		
		let isOff = mode != .Off
		
		var colour = NSColor.controlTextColor
		
		if mode == .Off {
			colour = NSColor.disabledControlTextColor
		}
		
		for item in desArray {
			item.textColor = colour
		}
	
		configLabel.textColor = colour
	
		showTitleCheckbox.isEnabled = isOff
		showEndTimeCheckbox.isEnabled = isOff
		showLeftTextCheckbox.isEnabled = isOff
		showPercentageCheckbox.isEnabled = isOff
		limitTitleLengthButton.isEnabled = isOff
		configButton.isEnabled = isOff
		
		
		
		
		
		var buttonEnabled = false
		var controlEnabled = false
		
		
		if mode != .Off {
			
			if HLLDefaults.statusItem.showTitle {
				
				buttonEnabled = true
				
				if HLLDefaults.statusItem.limitStatusItemTitle {
					
					controlEnabled = true
					
				}
				
			}
			
		}
		
		limitTitleLengthButton.isEnabled = buttonEnabled
		limitTitleLengthBox.isEnabled = controlEnabled
		limitTitleLengthStepper.isEnabled = controlEnabled
		
		
		
		updateUnitsMenu(enabled: HLLDefaults.statusItem.mode == .Minute)
		
		
		
	}
	
    func updateUnitsMenu(enabled: Bool) {
		
		unitsMenu.removeAllItems()
		
		if HLLDefaults.statusItem.mode == .Off {
			
			unitsLabel.textColor = NSColor.disabledControlTextColor
			unitsMenu.isEnabled = false
			
			
		} else {
		
			unitsLabel.textColor = NSColor.controlTextColor
			unitsMenu.isEnabled = true
			
        if enabled == true {
			
            unitsMenu.addItems(withTitles: [shortUnitsMenuItemText,fullUnitsMenuItemText])
            
            if HLLDefaults.statusItem.useFullUnits == true {
                unitsMenu.selectItem(withTitle: fullUnitsMenuItemText)
            } else {
                unitsMenu.selectItem(withTitle: shortUnitsMenuItemText)
            }
            
        } else {
			
			unitsMenu.addItems(withTitles: [timerFullText, timerShortText])
			
			if HLLDefaults.statusItem.hideTimerSeconds == true {
				unitsMenu.selectItem(withTitle: timerShortText)
			} else {
				unitsMenu.selectItem(withTitle: timerFullText)
			}
            
        }
		
		
		}
		
		HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
	@IBOutlet weak var unitsLabel: NSTextField!
	
	@IBOutlet weak var des1: NSTextField!
	@IBOutlet weak var des2: NSTextField!
	@IBOutlet weak var des3: NSTextField!
    @IBOutlet weak var des4: NSTextField!
	
	
	@objc func generateStatusItemPreview() {
		
		if previewEvent == nil {
			
			previewEvent = createPreviewEvent()
			
		}
		
	
		
		if let preview = previewEvent {
			
        
        switch HLLDefaults.statusItem.mode {
            
        case .Off:
            
			self.statusItemPreviewText.isHidden = true
			self.previewIcon.isHidden = false
            
        case .Timer:
            
			self.statusItemPreviewText.isHidden = false
			self.previewIcon.isHidden = true
            
            
			let data = CountdownStringGenerator.generateStatusItemString(event: preview, mode: HLLDefaults.statusItem.mode)
			
			self.statusItemPreviewText.stringValue = data!
            
        case .Minute:
            
			self.statusItemPreviewText.isHidden = false
			self.previewIcon.isHidden = true
        
			
			self.statusItemPreviewText.stringValue = CountdownStringGenerator.generateStatusItemMinuteModeString(event: preview)
            
        }
			
			
			
		}
			
		
	}
	
	@IBAction func limitClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
			HLLDefaults.statusItem.limitStatusItemTitle = state
        
			self.adaptForMode(HLLDefaults.statusItem.mode)
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
	}
	
	@IBAction func textBoxModified(_ sender: NSTextField) {
		
		if let int = Int(sender.stringValue) {
			HLLDefaults.statusItem.statusItemTitleLimit = int
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
		DispatchQueue.main.async {
			self.updateTextBoxValue()
		}
		
		
	}
	
	func updateTextBoxValue() {
		
		limitTitleLengthBox.stringValue = String(HLLDefaults.statusItem.statusItemTitleLimit)
		
	}
	
	@IBAction func stepperClicked(_ sender: NSStepper) {
		
		if sender.integerValue == 2 {
			HLLDefaults.statusItem.statusItemTitleLimit += 1
		} else if sender.integerValue == 0 {
			HLLDefaults.statusItem.statusItemTitleLimit -= 1
		}
		
		sender.integerValue = 1
		HLLDefaultsTransfer.shared.userModifiedPrferences()
		updateTextBoxValue()
		
		
	}
	
	func getEventMode(from string: String) -> StatusItemEventMode? {
		
		if string == preferSoonestText {
			return .bothPreferSoonest
		}
		
		if string == preferCurrentText {
			return .bothPreferCurrent
		}
		
		if string == onlyCurrentText {
			return .currentOnly
		}
		
		if string == onlyUpcomingText {
			return .upcomingOnly
		}
		
		if string == onlySelected {
			return .onlySelected
		}
		
		return nil
	}
	
	func getString(from eventMode: StatusItemEventMode) -> String {
		
		switch eventMode {
			
			 
		case .bothPreferSoonest:
			return self.preferSoonestText
		case .bothPreferCurrent:
			return self.preferCurrentText
		case .currentOnly:
			return self.onlyCurrentText
		case .upcomingOnly:
			return self.onlyUpcomingText
		case .onlySelected:
			return self.onlySelected
		}
		
		
	}
    
}

class SelectView: NSView {
	
	override func mouseDown(with event: NSEvent) {
		// print("Selectview")
		NSApp.keyWindow?.makeFirstResponder(nil)
		
		
		
		/*if let window = NSApp.keyWindow?.contentViewController {
			
			for child in window.children {
				
				if let deselect = child as? TableDeselect {
					deselect.deselectTable()
				}
				
			}
			
		}*/
		
	}
	
}



protocol TableDeselect {
	
	func deselectTable()
	
}

