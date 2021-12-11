//
//  StatusItemPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import Preferences
import LaunchAtLogin
import EventKit

final class StatusItemPreferenceViewController: NSViewController, Preferenceable {
	
	let toolbarItemTitle = "Status Item"
    let toolbarItemIcon = NSImage(named: "MenuSI")!
    
    override var nibName: NSNib.Name? {
        return "StatusItemPreferencesView"
    }
    
    @IBOutlet weak var statusItemPreviewText: NSTextField!
    
    @IBOutlet weak var modeRadio_Off: NSButton!
    @IBOutlet weak var modeRadio_Timer: NSButton!
    @IBOutlet weak var modeRadio_Minute: NSButton!
    
    @IBOutlet weak var showTitleCheckbox: NSButton!
    @IBOutlet weak var showLeftTextCheckbox: NSButton!
    @IBOutlet weak var showPercentageCheckbox: NSButton!
	@IBOutlet weak var showEndTimeCheckbox: NSButton!
	
    @IBOutlet weak var doneAlertsCheckbox: NSButton!
    
    @IBOutlet weak var previewIcon: NSImageView!
    @IBOutlet weak var unitsMenu: NSPopUpButton!
	
    let shortUnitsMenuItemText = "Use short units (hr, min)"
    let fullUnitsMenuItemText = "Use full units (hours, minutes)"
    
    let timerFullText = "Include seconds remaining"
	let timerShortText = "Don't include seconds remaining"
	
	let timer = RepeatingTimer(time: 0.2)
	
	var previewEvent: HLLEvent?
	
	let previewEventData = HLLEvent(title: "Event", start: Date().addingTimeInterval(1), end: Date().addingTimeInterval(5401), location: nil)
	
    @IBAction func modeRadioChanged(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
		
        if let mode = StatusItemMode(rawValue: Int(sender.identifier!.rawValue)!) {
            
            HLLDefaults.statusItem.mode = mode
			
			
		
				
			if mode == .Off {
				self.des1.textColor = NSColor.disabledControlTextColor
				self.des2.textColor = NSColor.disabledControlTextColor
				self.des3.textColor = NSColor.disabledControlTextColor
                self.des4.textColor = NSColor.disabledControlTextColor
				self.des5.textColor = NSColor.disabledControlTextColor
				
			} else {
				self.des1.textColor = NSColor.controlTextColor
				self.des2.textColor = NSColor.controlTextColor
				self.des3.textColor = NSColor.controlTextColor
                self.des4.textColor = NSColor.controlTextColor
				self.des5.textColor = NSColor.controlTextColor
			}
			
            let isOff = mode != .Off
			
            
			self.showTitleCheckbox.isEnabled = isOff
			self.showLeftTextCheckbox.isEnabled = isOff
			self.showPercentageCheckbox.isEnabled = isOff
			self.showEndTimeCheckbox.isEnabled = isOff
            self.doneAlertsCheckbox.isEnabled = isOff
			self.updateUnitsMenu(enabled: mode == .Minute)
            
        }
        
			self.generateStatusItemPreview()
			
		}
        
    }
    
    @IBAction func showTitleClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showTitle = state
        
			self.generateStatusItemPreview()
			
		}
        
    }
    
    @IBAction func doneAlertsClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.statusItem.doneAlerts = state
            
        }
        
    }
    
    
    @IBAction func showLeftText(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showLeftText = state
        
			self.generateStatusItemPreview()
			
		}
        
    }
    
	@IBAction func showEndTimeClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
			
			var state = false
			if sender.state == .on { state = true }
			HLLDefaults.statusItem.showEndTime = state
			
			self.generateStatusItemPreview()
			
		}
		
		
	}
	
    @IBAction func showPercentageClicked(_ sender: NSButton) {
		
		DispatchQueue.main.async {
		
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.statusItem.showPercentage = state
        
			self.generateStatusItemPreview()
			
		}
        
    }
    
    @IBAction func unitsClicked(_ sender: NSPopUpButton) {
		
		DispatchQueue.main.async {
		
        switch sender.selectedItem!.title {
            
		case self.fullUnitsMenuItemText:
            HLLDefaults.statusItem.useFullUnits = true
			
		case self.shortUnitsMenuItemText:
			HLLDefaults.statusItem.useFullUnits = false
		
		case self.timerShortText:
			HLLDefaults.statusItem.hideTimerSeconds = true
			
		case self.timerFullText:
			HLLDefaults.statusItem.hideTimerSeconds = false
			
        default:
			break
			
        }
        
			self.generateStatusItemPreview()
			
		}
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		previewIcon.alphaValue = 1.0
	//	previewIcon.contentTintColo
		
        switch HLLDefaults.statusItem.mode {
            
        case .Off:
            modeRadio_Off.state = NSControl.StateValue.on
        case .Timer:
            modeRadio_Timer.state = NSControl.StateValue.on
        case .Minute:
            modeRadio_Minute.state = NSControl.StateValue.on
            
        }
		
		if HLLDefaults.statusItem.mode == .Off {
			self.des1.textColor = NSColor.disabledControlTextColor
			self.des2.textColor = NSColor.disabledControlTextColor
			self.des3.textColor = NSColor.disabledControlTextColor
            self.des4.textColor = NSColor.disabledControlTextColor
			self.des5.textColor = NSColor.disabledControlTextColor
			
		} else {
			self.des1.textColor = NSColor.controlTextColor
			self.des2.textColor = NSColor.controlTextColor
			self.des3.textColor = NSColor.controlTextColor
            self.des4.textColor = NSColor.controlTextColor
			self.des5.textColor = NSColor.controlTextColor
		}
        
        var SITitleState = NSControl.StateValue.off
        if HLLDefaults.statusItem.showTitle == true { SITitleState = .on }
        showTitleCheckbox.state = SITitleState
        
        var SILeftState = NSControl.StateValue.off
        if HLLDefaults.statusItem.showLeftText == true { SILeftState = .on }
        showLeftTextCheckbox.state = SILeftState
        
        
        var SIDoneAlertsState = NSControl.StateValue.off
        if HLLDefaults.statusItem.doneAlerts == true { SIDoneAlertsState = .on }
        doneAlertsCheckbox.state = SIDoneAlertsState
        
        var SIPercentageState = NSControl.StateValue.off
        if HLLDefaults.statusItem.showPercentage == true { SIPercentageState = .on }
        showPercentageCheckbox.state = SIPercentageState
		
		var SIEndState = NSControl.StateValue.off
		if HLLDefaults.statusItem.showEndTime == true { SIEndState = .on }
		showEndTimeCheckbox.state = SIEndState
        
        let mode = HLLDefaults.statusItem.mode
        let isOff = mode != .Off
        showTitleCheckbox.isEnabled = isOff
		showEndTimeCheckbox.isEnabled = isOff
        showLeftTextCheckbox.isEnabled = isOff
        showPercentageCheckbox.isEnabled = isOff
		doneAlertsCheckbox.isEnabled = isOff
        
        updateUnitsMenu(enabled: HLLDefaults.statusItem.mode == .Minute)
        
        // Setup stuff here
		
		previewEvent = previewEventData
		
		statusItemPreviewText.font = NSFont.monospacedDigitSystemFont(ofSize: statusItemPreviewText.font!.pointSize, weight: .medium)
		
		DispatchQueue.main.async {
			self.generateStatusItemPreview()
			
		}
		
		timer.eventHandler = {
			
			
			self.timer.eventHandler = {
				
				DispatchQueue.main.async {
				self.generateStatusItemPreview()
					
				}
				
			}
			
		}
		
		timer.resume()
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
        
    }
    
	@IBOutlet weak var unitsLabel: NSTextField!
	
	@IBOutlet weak var des1: NSTextField!
	@IBOutlet weak var des2: NSTextField!
	@IBOutlet weak var des3: NSTextField!
    @IBOutlet weak var des4: NSTextField!
	@IBOutlet weak var des5: NSTextField!
	
	
	func generateStatusItemPreview() {
		
		DispatchQueue.main.async {
			
		
		var Pevent: HLLEvent?
			
		if let primary = EventCache.primaryEvent, primary.holidaysTerm == nil {
			
			Pevent = primary
			
		} else if let firstCurrent = EventCache.currentEvents.first, firstCurrent.holidaysTerm == nil {
			
			Pevent = firstCurrent
			
		} else {
			
			if let safePevent = Pevent {
				
			
			if safePevent.endDate.timeIntervalSinceNow < 1 {
				
				self.previewEvent = self.previewEventData
				
			}
				
			}
			
			Pevent = self.previewEvent
			
			
			
		}
			
		
		
		
		
		if let preview = Pevent {
			
			
			
        
        switch HLLDefaults.statusItem.mode {
            
        case .Off:
            
			self.statusItemPreviewText.isHidden = true
			self.previewIcon.isHidden = false
            
        case .Timer:
            
			self.statusItemPreviewText.isHidden = false
			self.previewIcon.isHidden = true
            
            let stringGenerator = CountdownStringGenerator()
            let data = stringGenerator.generateStatusItemString(event: preview)
			
			self.statusItemPreviewText.stringValue = data ?? ""
            
        case .Minute:
            
			self.statusItemPreviewText.isHidden = false
			self.previewIcon.isHidden = true
            
            let stringGenerator = CountdownStringGenerator()
			
			
			self.statusItemPreviewText.stringValue = stringGenerator.generateStatusItemMinuteModeString(event: preview)!
            
        }
			
			
			
		} else {
			
			self.previewEvent = self.previewEventData
			
		}
			
		}
	}
	
    
    
}
