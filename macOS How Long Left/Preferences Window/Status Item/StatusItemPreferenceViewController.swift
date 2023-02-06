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
    

    @IBOutlet weak var showTitleCheckbox: NSButton!
    @IBOutlet weak var showPercentageCheckbox: NSButton!
	@IBOutlet weak var showEndTimeCheckbox: NSButton!


	let formatter = NumberFormatter()
	
	var timer: Timer?

	
	
	let preferSoonestText = "Current & Upcoming (Prefer Soonest)"
	let preferCurrentText = "Current & Upcoming (Prefer Current)"
	
	let onlyCurrentText = "Only Current Events"
	let onlyUpcomingText = "Only Upcoming Events"
	
	let onlySelected = "Only Selected Events"

	
	var previewEvent: HLLEvent?
	
	override func viewWillAppear() {
        
		formatter.allowsFloats = false
		//limitTitleLengthBox.formatter = formatter
		
	
		
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
		updateTextBoxValue()
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.preferredContentSize = CGSize(width: 370, height: 388)

		
		
		let menu = NSMenu()
		
		menu.addItem(NSMenuItem.makeItem(title: self.preferSoonestText))
		menu.addItem(NSMenuItem.makeItem(title: self.preferCurrentText))
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem.makeItem(title: self.onlyCurrentText))
		menu.addItem(NSMenuItem.makeItem(title: self.onlyUpcomingText))
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem.makeItem(title: self.onlySelected))
		

		
		let type = HLLDefaults.statusItem.eventMode
		
		
		
	
		var SITitleState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showTitle == true { SITitleState = .on }
		showTitleCheckbox.state = SITitleState
		
		var SILeftState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showLeftText == true { SILeftState = .on }

		
		var SIPercentageState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showPercentage == true { SIPercentageState = .on }
		showPercentageCheckbox.state = SIPercentageState
		
		var SIEndState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showEndTime == true { SIEndState = .on }
		showEndTimeCheckbox.state = SIEndState
		
		// Setup stuff here
		
		previewEvent = createPreviewEvent()


		
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
		
			
		}
			
			
			
			HLLStatusItemManager.shared.updateAll()
        
    }
		
	}
	
	@IBAction func includeCurrentClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showCurrent = state
			
			
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
	}
	
	@IBAction func includeUpcomingClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showUpcoming = state
			
			
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
		
		
	}
	

	
    @IBAction func showTitleClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showTitle = state
			
			HLLDefaultsTransfer.shared.userModifiedPrferences()
			
		}
        
    }
	
    
    @IBAction func showLeftText(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showLeftText = state
        

			HLLDefaultsTransfer.shared.userModifiedPrferences()
		}
        
    }
    
	@IBAction func showEndTimeClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showEndTime = state
			

			HLLDefaultsTransfer.shared.userModifiedPrferences()
		}
		
		
	}
	
    @IBAction func showPercentageClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showPercentage = state
        
			
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

