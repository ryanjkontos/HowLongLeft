//
//  GeneralPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import Preferences


final class MagdalenePreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "Magdalene"
    let toolbarItemIcon = NSImage(named: "MagdaleneIcon")!
    
    override var nibName: NSNib.Name? {
        return "MagdalenePreferencesView"
    }
    
    var magdaleneHolidays = MagdaleneSchoolHolidays()
    
    let schoolAnalyser = SchoolAnalyser()
    
    @IBOutlet weak var magdaleneFeaturesButton: NSButton!
   // @IBOutlet weak var doDoublesButton: NSButton!
    @IBOutlet weak var shortenTitlesButton: NSButton!
    @IBOutlet weak var adjustTimesButton: NSButton!
    @IBOutlet weak var showBreaksButton: NSButton!
    @IBOutlet weak var countDownSchoolHolidaysButton: NSButton!
    @IBOutlet weak var showHolidaysInStatusItemButton: NSButton!
    @IBOutlet weak var hideNonMagdaleneBreaksButton: NSButton!
    @IBOutlet weak var showHolidaysPercentageClicked: NSButton!
    @IBOutlet weak var edvalButtonButton: NSButton!
    
    @IBOutlet weak var des1: NSTextField!
    @IBOutlet weak var des2: NSTextField!
    @IBOutlet weak var des3: NSTextField!
    @IBOutlet weak var des4: NSTextField!
    @IBOutlet weak var des5: NSTextField!
    @IBOutlet weak var des6: NSTextField!
    @IBOutlet weak var des7: NSTextField!
    @IBOutlet weak var holidaysDateLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if HLLDefaults.magdalene.manuallyDisabled == false {
            magdaleneFeaturesButton.state = .on
        } else {
            magdaleneFeaturesButton.state = .off
        }
        
        
        if HLLDefaults.magdalene.showEdvalButton == true {
            edvalButtonButton.state = .on
        } else {
            edvalButtonButton.state = .off
        }
        
        if HLLDefaults.magdalene.shortenTitles == true {
            shortenTitlesButton.state = .on
        } else {
            shortenTitlesButton.state = .off
        }
        
        if HLLDefaults.magdalene.adjustTimes == true {
            adjustTimesButton.state = .on
        } else {
            adjustTimesButton.state = .off
        }
        
        if HLLDefaults.magdalene.showBreaks == true {
            showBreaksButton.state = .on
        } else {
            showBreaksButton.state = .off
        }
        
        if HLLDefaults.magdalene.hideNonMagdaleneEvents == true {
            hideNonMagdaleneBreaksButton.state = .off
        } else {
            showBreaksButton.state = .on
        }
        
        if HLLDefaults.magdalene.doHolidays == true {
            countDownSchoolHolidaysButton.state = .on
        } else {
            countDownSchoolHolidaysButton.state = .off
        }
        
        if HLLDefaults.magdalene.doHolidaysInStatusItem == true {
            showHolidaysInStatusItemButton.state = .on
        } else {
            showHolidaysInStatusItemButton.state = .off
        }
        
        if HLLDefaults.magdalene.showHolidaysPercent == true {
            showHolidaysPercentageClicked.state = .on
        } else {
            showHolidaysPercentageClicked.state = .off
        }
        
        if let holidaysEvent = magdaleneHolidays.getNextHolidays() {
            
            let secondsLeft = holidaysEvent.endDate.timeIntervalSince(holidaysEvent.startDate)-1
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day]
            formatter.unitsStyle = .full
            let countdownText = formatter.string(from: secondsLeft+60)!
            holidaysDateLabel.stringValue = "\(holidaysEvent.startDate.formattedDate()) - \(holidaysEvent.endDate.formattedDate()) (\(countdownText))"
            
        } else {
            
            
            holidaysDateLabel.stringValue = "Show School Holidays in How Long Left."
            
        }
        
        updateButtonsState()
       
    }
    
    func updateButtonsState() {
        
        let state = HLLDefaults.magdalene.manuallyDisabled
        // doDoublesButton.isEnabled = !state
        shortenTitlesButton.isEnabled = !state
        adjustTimesButton.isEnabled = !state
        showBreaksButton.isEnabled = !state
        countDownSchoolHolidaysButton.isEnabled = !state
        showHolidaysPercentageClicked.isEnabled = !state
        showHolidaysInStatusItemButton.isEnabled = !state
        self.hideNonMagdaleneBreaksButton.isEnabled = !state
        self.edvalButtonButton.isEnabled = !state
        
        var col: NSColor
        
        if !state == false {
            
            col = NSColor.disabledControlTextColor
            
        } else {
            
            col = NSColor.textColor
            
        }
        
        des1.textColor = col
        des2.textColor = col
        des3.textColor = col
        des4.textColor = col
        des5.textColor = col
        des6.textColor = col
        des7.textColor = col
        holidaysDateLabel.textColor = col
        
    }
    
    
    @IBAction func magdaleneFeaturesButtonClicked(_ sender: NSButton) {
        
        
            let on = sender.state == .on
            
            HLLDefaults.magdalene.manuallyDisabled = !on
            
        self.updateButtonsState()
        
        
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
        
            
    }
    
    
    @IBAction func doDoublesButtonClicked(_ sender: NSButton) {
        
         DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.magdalene.doDoubles = state
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
        
        }
            
    }
    
    @IBAction func shortenTitlesButtonClicked(_ sender: NSButton) {
        
         DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.magdalene.shortenTitles = state
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
       
        }
            
    }
    
    @IBAction func adjustTimesButtonClicked(_ sender: NSButton) {
        
         DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.magdalene.adjustTimes = state
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
        
        }
            
    }
    
    @IBAction func showBreaksButtonClicked(_ sender: NSButton) {
        
         DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.magdalene.showBreaks = state
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
        
        }
            
    }
    
    @IBAction func hideNonMagdaleneEventsClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.magdalene.hideNonMagdaleneEvents = !state
            NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
            
        }

        
    }
    
    @IBAction func edvalButtonButtonClicked(_ sender: NSButton) {
       
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.magdalene.showEdvalButton = state
            
        }
        
        
    }
    
    
    @IBAction func showSchoolHolidaysButtonClicked(_ sender: NSButton) {
        
         DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.magdalene.doHolidays = state
        NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
        
        }
            
    }
    
    @IBAction func showHolidaysInStatusItemClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.magdalene.doHolidaysInStatusItem = state
            NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
            
        }
        
        
    }
    
    @IBAction func showHolidaysPercentageClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.magdalene.showHolidaysPercent = state
            NotificationCenter.default.post(name: Notification.Name("updateCalendar"), object: nil)
            
        }
        
    }
    

    
    
    
}
