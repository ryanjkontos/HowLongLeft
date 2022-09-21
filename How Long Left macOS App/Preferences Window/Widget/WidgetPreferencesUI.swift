//
//  RenamePreferencesUI.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI
import Preferences
import WidgetKit


@available(OSX 11.0, *)
final class WidgetPreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.widget
    var preferencePaneTitle: String = "Widget"
    
    let toolbarItemIcon = NSImage(systemSymbolName: "rectangle.3.offgrid", accessibilityDescription: nil)!
    
    var widgetCount = 0
    
    override var nibName: NSNib.Name? {
        return "WidgetPreferencesView"
    }
    
    @IBOutlet weak var calendarColButton: NSButton!
    @IBOutlet weak var selectedEventButton: NSButton!
    @IBOutlet weak var progressBarButton: NSButton!
    @IBOutlet weak var themeMenu: NSPopUpButton!
    
    @IBOutlet weak var updatingText: NSTextField!
    @IBOutlet weak var updatingSpinner: NSProgressIndicator!
    
    @IBOutlet weak var colourInfoText: NSTextField!
    
    override func viewDidLoad() {
        
        var colText = "Color"
        if Locale.current.usesMetricSystem {
            colText = "Colour"
        }
        
        colourInfoText.stringValue = "Use the \(colText.lowercased()) of an event's calendar to tint the countdown text and progress bar."
        calendarColButton.title = "Use Calendar \(colText)"
        
        self.preferredContentSize = CGSize(width: 500, height: 278)
        getWidgetCount()
    }
    
    override func viewWillAppear() {
        
        updatingText.isHidden = true
        updatingSpinner.isHidden = true
        
        calendarColButton.isOn = HLLDefaults.widget.tintCalendarColour
        selectedEventButton.isOn = HLLDefaults.widget.showSelected
        progressBarButton.isOn = HLLDefaults.widget.showProgressBar
        
        updateThemeMenu()
        
    }
    
    @IBAction func buttonClicked(_ sender: NSButton) {
       
        if sender == calendarColButton {
            HLLDefaults.widget.tintCalendarColour = sender.isOn
        }
        if sender == selectedEventButton {
            HLLDefaults.widget.showSelected = sender.isOn
        }
        if sender == progressBarButton {
            HLLDefaults.widget.showProgressBar = sender.isOn
        }
        
        updateWidget()
        
    }
    
    @IBAction func themeChanged(_ sender: NSPopUpButton) {
        
        
        HLLDefaults.widget.theme = WidgetTheme(rawValue: sender.selectedItem!.tag)!
        updateWidget()
    }
    
    
    func updateThemeMenu() {
        
        let lightText = "Light"
        let darkText = "Dark"
        
        var currentText = lightText
        
        if self.view.isDarkMode {
            currentText = darkText
        }
        
        let systemButton = HLLMenuItem(title: "System (\(currentText))")
        systemButton.tag = 0
        
        let lightButton = HLLMenuItem(title: lightText)
        lightButton.tag = 1
        
        let darkButton = HLLMenuItem(title: darkText)
        darkButton.tag = 2
        
        
        let menu = NSMenu()
        menu.items = [systemButton, lightButton, darkButton]
        
        themeMenu.menu = menu
        
        themeMenu.selectItem(at: HLLDefaults.widget.theme.rawValue)
        
    }
    
   
    func updateWidget() {
        
        DispatchQueue.main.async { [self] in
        
        WidgetCenter.shared.reloadAllTimelines()
        
        if widgetCount > 1 {
            updatingText.stringValue = "Updating Widgets..."
        } else {
            updatingText.stringValue = "Updating Widget..."
        }
            
        updatingText.isHidden = false
        updatingSpinner.startAnimation(nil)
        updatingSpinner.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            
            updatingText.isHidden = true
            updatingSpinner.stopAnimation(nil)
            updatingSpinner.isHidden = true
            
            }
            
        }
        
    }
    
    override func viewDidLayout() {
        
        updateThemeMenu()
        
    }
    
    func getWidgetCount() {
        
        widgetCount = 0
        
        WidgetCenter.shared.getCurrentConfigurations({ _ in
            
            self.widgetCount += 1
            
        })
        
    }
    
}

