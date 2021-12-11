//
//  TodayViewController.swift
//  How Long Left (macOS Widget)
//
//  Created by Ryan Kontos on 8/8/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, EventPoolUpdateObserver {

    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var endsInText: NSTextField!
    @IBOutlet weak var box: NSBox!
    
    let eventOnFont = NSFont.systemFont(ofSize: 22, weight: .regular)
    let noEventOnFont = NSFont.systemFont(ofSize: 17, weight: .regular)
    
    var checkedID = ""
    var selected: HLLEvent?
    
    let countdownTextGen = CountdownStringGenerator()
    let schoolAnalyser = SchoolAnalyser()
    
    var timer = Timer()
    var updateTimer = Timer()
    
    var widgetEvent: HLLEvent? {
        
        if let selected = self.selected {
            
            return selected
            
        }
        
        if let current = getStatusItemCurrentEvents().first {
            
            return current
            
        }
        
        if let upcoming = getNextUpcomingDayAllEvents().first {
            
            return upcoming
            
        }
        
        return nil
        
        
    }
    
    func getNextUpcomingDayAllEvents() -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        
        if HLLDefaults.general.showAllDayInStatusItem == true {
            
            returnArray = HLLEventSource.shared.getUpcomingEventsFromNextDayWithEvents()
            
        } else {
            
            for event in HLLEventSource.shared.getUpcomingEventsFromNextDayWithEvents() {
                
                if event.isAllDay == false {
                    
                    returnArray.append(event)
                    
                }
                
            }
            
        }
        
        return returnArray
    }
    
    func getStatusItemCurrentEvents() -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        
        if HLLDefaults.general.showAllDayInStatusItem == true {
            
            returnArray = HLLEventSource.shared.getCurrentEvents()
            
        } else {
            
            for event in HLLEventSource.shared.getCurrentEvents() {
                
                if event.isAllDay == false {
                    
                    returnArray.append(event)
                    
                }
            }
        }
        
        return returnArray
        
    }

    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        return NSEdgeInsets(top: 7, left: 5, bottom: 7, right: 5)
    }
    
    override func viewDidLoad() {

        ProStatusManager.shared = ProStatusManager()
        
        timerLabel.isHidden = true
        endsInText.isHidden = true
        box.isHidden = true
        
        HLLEventSource.shared.addEventPoolObserver(self)
        
        timerLabel.font = NSFont.monospacedDigitSystemFont(ofSize: timerLabel.font!.pointSize, weight: .light)
        
  
    }
    
    override func viewDidAppear() {
        HLLEventSource.shared.updateEventPool()
    }
    
   
    func eventPoolUpdated() {
        
        mainRun()
        
        checkSelected()
        
        timer = Timer(fireAt: Date(), interval: 0.5, target: self, selector: #selector(mainRun), userInfo: nil, repeats: true)
               RunLoop.main.add(timer, forMode: .common)
               

    }
    
    
    func checkSelected() {
        
        DispatchQueue.global(qos: .default).async {
        
        var setTo: HLLEvent?
        
        if let id = HLLDefaults.defaults.string(forKey: "SelectedEvent") {
            
            if id != self.checkedID {
                
                let events = HLLEventSource.shared.eventPool
                
                for event in events {
                    
                    if event.persistentIdentifier == id, event.completionStatus != .Done {
                        
                        setTo = event
                        break
                        
                    }
                    
                    
                }
                
                
                
            }
            
        }
        
            self.selected = setTo
            
        }
        
    }
    
    @objc func mainRun() {
        
        DispatchQueue.main.async {
        
            self.endsInText.isHidden = false
            
        self.checkSelected()
        
            if let event = self.widgetEvent {
            
                self.endsInText.font = self.eventOnFont
            self.endsInText.stringValue = "\(event.title) \(event.countdownTypeString) in"
                self.timerLabel.stringValue = self.countdownTextGen.generatePositionalCountdown(event: event)
            
            self.box.isHidden = true
            
            if let calCol = event.calendar?.color {
                
                self.box.fillColor = calCol
                self.box.isHidden = false
                
            }
            
            if let calCol = event.associatedCalendar?.color {
                
                self.box.fillColor = calCol
                self.box.isHidden = false
                
            }
        
            self.timerLabel.isHidden = false
            self.endsInText.alignment = .left
            
        } else {
            
                self.endsInText.font = self.noEventOnFont
                self.box.isHidden = true
                self.timerLabel.isHidden = true
                self.endsInText.alignment = .center
                self.endsInText.stringValue = "No Events"
        
        }
        
        }
        
    }
    
    var eventChangeTimer: Timer?
    
    @objc func calendarDidChange() {
        
        print("CalChange: Calendar change called")
        
        if eventChangeTimer == nil {
            
            eventChangeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.doCalendarUpdateForCalendarChange), userInfo: nil, repeats: false)
            print("CalChange: Set timer")
            
        }
        
    }
    
    @objc func doCalendarUpdateForCalendarChange() {
        
        if !HLLEventSource.isRenaming {
            
            DispatchQueue.global(qos: .default).async {
                
                HLLEventSource.shared.updateEventPool()
                HLLEventSource.shared.eventStore.reset()
                
            }
            
            print("CalChange: Updating calendar at \(Date().formattedTime()) due to cal change")
            
        }
        
        eventChangeTimer = nil
        
        
        
    }

}
