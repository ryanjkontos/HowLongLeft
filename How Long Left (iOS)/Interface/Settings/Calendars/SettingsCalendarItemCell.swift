//
//  SettingsCalendarItemCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 24/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import EventKit

class SettingsCalendarItemCell: UITableViewCell {
    
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var calColBox: UIView!
    @IBOutlet weak var calendarItemTitle: UILabel!
    @IBOutlet weak var calendarToggle: UISwitch!
    var delegate: CalendarSelectTableViewController!
    
    var calendar: EKCalendar!

    func setCalendarItem(Calendar: EKCalendar, delegate: CalendarSelectTableViewController) {
        
        self.calendar = Calendar
        self.delegate = delegate
        
        calendarToggle.isOn = HLLDefaults.calendar.enabledCalendars.contains(Calendar.calendarIdentifier)
        
        if let col = Calendar.cgColor {
            
            #if targetEnvironment(macCatalyst)
            let uiCOL = UIColor(cgColor: col).catalystAdjusted()
            #else
            let uiCOL = UIColor(cgColor: col)
            #endif
            
            
            
            calColBox.backgroundColor = uiCOL
        
        }
            
        calendarItemTitle.text = Calendar.title
        
    }
    
    @IBAction func toggled(_ sender: UISwitch) {
        
        DispatchQueue.main.async {
        
            CalendarDefaultsModifier.shared.setState(enabled: sender.isOn, calendar: self.calendar)
       
            self.delegate.setupSelectAllButton()
        HLLDefaultsTransfer.shared.userModifiedPrferences()
            
        }
        
    }
    
    func updateToggle() {
        
        if calendarToggle.isOn != HLLDefaults.calendar.enabledCalendars.contains(calendar.calendarIdentifier) {
            
            calendarToggle.setOn(!calendarToggle.isOn, animated: true)
            
        }
        
        
        
    }
    
    
}
