//
//  InterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 15/10/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import UserNotifications


class InterfaceController: WKInterfaceController, HLLCountdownController, DataSourceChangedDelegate, SchoolModeChangedDelegate {
    
    func percentageMilestoneReached(milestone percentage: Int, event: HLLEvent) {
        
    }
    
    func eventStarted(event: HLLEvent) {
        
    }
    
    
    @IBOutlet var hoursTimerLabel: WKInterfaceTimer!
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var endsInLabel: WKInterfaceLabel!
    @IBOutlet weak var NothingOnGroup: WKInterfaceGroup!
    @IBOutlet weak var NothingOnAndNoUpcomingGroup: WKInterfaceGroup!
    @IBOutlet weak var CountdownGroup: WKInterfaceGroup!
    @IBOutlet weak var nothingOnText: WKInterfaceLabel!
    @IBOutlet weak var nothingOnNoUpcomingText: WKInterfaceLabel!
    @IBOutlet weak var upcomingEventsTable: WKInterfaceTable!
    @IBOutlet weak var nextEventTimer: WKInterfaceTimer!
    @IBOutlet var upcomingSection: WKInterfaceGroup!
    @IBOutlet var upcomingTableDateInfoLabel: WKInterfaceLabel!
    @IBOutlet var currentEventTableGroup: WKInterfaceGroup!
    @IBOutlet var currentTable: WKInterfaceTable!
    
    let Hdefaults = HLLDefaults()
    let complication = CLKComplicationServer.sharedInstance()
    var eventMonitor: EventTimeRemainingMonitor?
    let calendarData = EventDataSource()
    var endCheckTimer: Timer!
    let defaults = HLLDefaults.defaults
    var currentTableIdentifiers = ""
    var currentCurrentIdentifier = ""
    var nothingOnInfo = ""
    var generatedEventRows = [eventRowInstance]()
    var NXOdays: Double?
    var NXOdaysString: String?
    var nextOccurFinder = EventNextOccurenceFinder()
    var isShowingNextOccurButton = false
    var hasGenedTable = false
    let percentageCalculator = PercentageCalculator()
    var cdDate: Date?
    var upcoming = [HLLEvent]()
    //var current: HLLEvent?
    var currentEvents = [HLLEvent]()
    var nextOccurEvent: HLLEvent?
    var combinedCurrentAndUpcoming = [HLLEvent]()
    let schoolAnalyser = SchoolAnalyser()
    var UIEvents = [HLLEvent]()

    var arrayOfCurrentUpcomingTableIDS = [String]()
    
    func schoolModeChanged() {
        routine()
        
        DispatchQueue.main.async {
            self.updateComplication()
        }
    }
    
    func setUIHidden(_ hidden: Bool) {
        
        NothingOnGroup.setHidden(hidden)
        NothingOnAndNoUpcomingGroup.setHidden(hidden)
        CountdownGroup.setHidden(hidden)
        upcomingSection.setHidden(hidden)
        
    }
    
    @IBAction func refreshClicked() {
        
        
        routine()
        
        DispatchQueue.main.async {
            self.schoolAnalyser.analyseCalendar()
        }
        DispatchQueue.main.async {
            self.updateComplication()
        }
        
        
        
    }
    
    @IBAction func settingsTapped() {
        
        self.presentController(withName: "CalSettings", context: nil)
        
    }
    
    
    @IBAction func presentDebugMenu() {
        
        DispatchQueue.main.async {
        
        self.presentController(withName: "Prefs", context: nil)
        
        }
        
    }
    
    
    
    func updateComplication() {
        
        DispatchQueue.main.async {
        
            if let activeComplicationsArray = self.complication.activeComplications {
            
                 if ComplicationDataStatusHandler.shared.complicationIsUpToDate() == false {
            
                    
                    
            for complicationItem in activeComplicationsArray {
                
               
                print("Reload1")
               
                
                     self.complication.reloadTimeline(for: complicationItem)
                    
                
                
                    }
                
            }
            
            
        }
            
        }
        
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        
        if segueIdentifier == "eventInfoSegue" || segueIdentifier == "currentSegue" {
        
        var combinedArray = [HLLEvent]()
            
            for (i, event) in self.currentEvents.enumerated() {
                
                if i != 0 {
                    
                    combinedArray.append(event)
                    
                }
                
            }
            
        combinedArray.append(contentsOf: upcoming)
            
        let event = combinedArray[rowIndex]
            
        print("Seguing with \(event.title)")
            
            return (event, nextOccurEvent)
            
        } else {
            
            return nil
            
        }
        
    }
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        
        
     //   HLLDefaults.shared.loadDefaultsFromCloud()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        schoolAnalyser.analyseCalendar()
        
        self.routine()
        
        DispatchQueue.main.async {
            
            print("Awake")
            
            
            self.eventMonitor = EventTimeRemainingMonitor(delegate: self as HLLCountdownController)
            self.schoolAnalyser.addSchoolMOdeChangedDelegate(delegate: self)
            
            
            
            WatchSessionManager.sharedManager.addDataSourceChangedDelegate(delegate: self)
            
            let center = UNUserNotificationCenter.current()
            // Request permission to display alerts and play sounds.
            center.requestAuthorization(options: [.alert, .sound])
            { (granted, error) in
                
                
            }
            
            if WKExtension.shared().applicationState == .active {
                
                self.endCheckTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.checkForEnd), userInfo: nil, repeats: true)
                
            }
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.request),
                name: .EKEventStoreChanged,
                object: nil)
            
            
            var debug = false
            
            #if DEBUG
            debug = true
            #endif
            
            if let entries = CLKComplicationServer.sharedInstance().activeComplications {
                
                if ComplicationDataStatusHandler.shared.complicationIsUpToDate() || debug == true {
                    
                   
                    
                    for complicationItem in entries  {
                        
                         print("Reload2")
                        
                        CLKComplicationServer.sharedInstance().reloadTimeline(for: complicationItem)
                        
                    }
                    
                    
                    
                }
            }
            
            
            
            
            
            let bh = BackgroundUpdateHandler(); bh.scheduleComplicationUpdate()
            
            
        }

        
    }
    
  /*  @objc private func cloudDefaultsChanged() {
        
        HLLDefaults.shared.loadDefaultsFromCloud()
        
    }
    
    @objc private func defaultsChanged() {
        
        HLLDefaults.shared.exportDefaultsToCloud()
        
        
    } */
    
    func routine() {
        
        
        self.getEvents()
        
        
        self.generateUpcomingEventTableText(events: self.upcoming)
        
        if self.currentEvents != UIEvents || self.currentEvents.isEmpty == true {
        
            self.updateCountdownUI(events: self.currentEvents)
            
        }
            
        
      
        
        
           
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        if WKExtension.shared().applicationState == .active {
            
            self.endCheckTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.checkForEnd), userInfo: nil, repeats: true)
            
        }

        
        
        print("Will activate")
        self.routine()
            
            
            
        
        
      
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
      //  upcomingEventsTable.setNumberOfRows(0, withRowType: "EventRowID")
        
        super.didDeactivate()
    
        
    }
    
    var infoDisplaySwitch = false
    
    @objc func checkForEnd() {
    
        if self.currentEvents.isEmpty == false {
            
            hoursTimerLabel.start()
            
        }
        
        
        for event in self.currentEvents {
            
            if event.endDate.timeIntervalSinceNow < 1 {
                
                self.routine()
                
            }
            
        }
        
        for event in self.upcoming {
            
            
            if event.startDate.timeIntervalSinceNow < 1 {
                
                self.routine()
                
            }
            
        }
        
        DispatchQueue.main.async {
        
            
            
            
            if let firstEvent = self.currentEvents.first {
                
                let percentText = "(\(self.percentageCalculator.calculatePercentageDone(event: firstEvent, ignoreDefaults: false)!) Done)"
    
                var finalText = percentText
                
                if let loc = firstEvent.location {
                    
                    if firstEvent.startDate.timeIntervalSinceNow > -600 {
                        
                        finalText = "(\(loc))"
                        
                }
                    
                }
                self.locationLabel.setText(finalText)
                self.locationLabel.setHidden(false)
            }
        }
        
        DispatchQueue.main.async {
            
            if HLLDefaults.defaults.bool(forKey: "ComplicationPurchased") == false {
                
                HLLDefaults.defaults.set(false, forKey: "ShowCompEnabledAlert")
                
            } else {
                
                if HLLDefaults.defaults.bool(forKey: "ShowCompEnabledAlert") == false {
                    
                    
                    HLLDefaults.defaults.set(true, forKey: "ShowCompEnabledAlert")
                    
                    let action = WKAlertAction(title: "OK", style: .default, handler: {})
                    
                  /*  var messageString = "Thanks for purchasing!"
                    
                    if SchoolAnalyser.privSchoolMode == .Magdalene {
                        
                       messageString = "Thanks for purchasing! (Unless you go to Magdalene, then you're welcome.)"
                        
                    } */
                    
                    
                    
                    self.presentAlert(withTitle: "Premium complication features are now enabled", message: nil, preferredStyle: .alert, actions: [action])
                    
                    
                }
                
                
            }

            
        }
        
        
    }
    
   @objc func request() {
    
    // Called when the eventstore changes.
  
    
        self.schoolAnalyser.analyseCalendar()
        
        self.routine()
    
    DispatchQueue.main.async {
    
            self.updateComplication()
        
    }
        
    
        
    }
    
    
    
    func updateDueToEventEnd(event: HLLEvent, endingNow: Bool) {
        
        routine()
        
        
        DispatchQueue.main.async {
            self.updateComplication()
        }
        
        
    }
    
    func milestoneReached(milestone seconds: Int, event: HLLEvent) {
        
    }
    
    func userInfoChanged() {
        
        self.routine()
        
        
        DispatchQueue.main.async {
            self.schoolAnalyser.analyseCalendar()
        }
        DispatchQueue.main.async {
            self.updateComplication()
        }
        
        
        
    }
    
    func getEvents() {
        
        var upcomingTemp = calendarData.getUpcomingEventsToday()
        
        if upcomingTemp.isEmpty == true {
            
            upcomingTemp = calendarData.getUpcomingEventsFromNextDayWithEvents()
        }
        
        upcoming = upcomingTemp
        
        currentEvents = calendarData.getCurrentEvents()
        
        
            if let NXO = self.upcoming.first {
        
        let cal: Calendar = Calendar(identifier: .gregorian)
        let midnightToday: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let eventStartMidnight: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: NXO.startDate)!
        let NXOsec = eventStartMidnight.timeIntervalSince(midnightToday)
            
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
        let formattedEnd = dateFormatter.string(from: NXO.startDate)
            
            self.NXOdays = NXOsec/60/60/24
            
                switch self.NXOdays {
            case 0:
                self.NXOdaysString = nil
            case 1:
                self.NXOdaysString = "tomorrow"
            default:
                self.NXOdaysString = formattedEnd
            }
            
            }
            
        
        
    }
    
    var updatedUIWith: HLLEvent?
    
    func updateCountdownUI(events: [HLLEvent]) {
        
        
        var currentArray = [HLLEvent]()
        
        currentArray.append(contentsOf: events)
        
        
            if let currentE = events.first {
            

            
            self.hoursTimerLabel.setDate(currentE.endDate.addingTimeInterval(1))
            self.hoursTimerLabel.start()
                
        
                
                
                self.nameLabel.setText("\(currentE.title)")
            
                
                if let cal = currentE.calendar {
                    
                    self.hoursTimerLabel.setTextColor(UIColor(cgColor: cal.cgColor))
                    
                } else {
                    
                    self.hoursTimerLabel.setTextColor(UIColor.orange)
                }
                
               self.nextOccurEvent = self.nextOccurFinder.findNextOccurrences(currentEvents: [currentE], upcomingEvents: self.calendarData.fetchEventsFromPresetPeriod(period: .Next2Weeks)).first
                

            self.showTimerUI(show: true)
                updatedUIWith = currentE
                
        } else {
            
                nextOccurEvent = nil
                
                self.hoursTimerLabel.stop()
                    
                
                self.showTimerUI(show: false)
            
                self.nothingOnInfo = "No Events Are On"
        
        
                if self.upcoming.isEmpty == false {
            
            
            if self.NXOdays == 0 {
            
                self.nothingOnInfo = "Nothing is on until \(self.upcoming[0].startDate.formattedTime())."
         //   nextEventTimer.setDate(upcoming[0].startDate)
           // nextEventTimer.start()
                self.nextEventTimer.setHidden(true)
         //   nextEventTimer.setHidden(false)
                
            } else if let uDay = self.NXOdaysString {
                
                self.nextEventTimer.setHidden(true)
                
                self.nothingOnInfo = "Nothing is on until \(uDay)."
                
            }
                }
        
        self.nothingOnNoUpcomingText.setText(self.nothingOnInfo)
        self.nothingOnText.setText(self.nothingOnInfo)
        
                updatedUIWith = nil
    }
        
        
        
            self.eventMonitor?.setCurrentEvents(events: currentArray)
        
     
       UIEvents = events
        
    }
    
    @objc func nextOccurTapped() {
        
      //  pushController(withName: "NextOccurView", context: nextOccurEvent)
        
    }
    
    
    
    func showTimerUI(show: Bool) {
        
        if show == false {
        
            //CountdownGroup.setHidden(true)
            CountdownGroup.setHidden(true)
            
        if upcoming.isEmpty == true {
            
            NothingOnAndNoUpcomingGroup.setHidden(false)
            NothingOnGroup.setHidden(true)
        } else {
            NothingOnAndNoUpcomingGroup.setHidden(true)
            NothingOnGroup.setHidden(false)
            
        }
        } else {
            
           // CountdownGroup.setHidden(false)
            
            CountdownGroup.setHidden(false)
            NothingOnAndNoUpcomingGroup.setHidden(true)
            NothingOnGroup.setHidden(true)
            
        }
        
        
    }
    
    var storedTableEvents = [HLLEvent]()
    var storedTableCurrentEvents = [HLLEvent]()
    
    func generateUpcomingEventTableText(events: [HLLEvent]) {
        
        var combinedTemp = self.currentEvents
        combinedTemp.append(contentsOf: events)
        
        if combinedTemp != combinedCurrentAndUpcoming {
        
        
        DispatchQueue.main.async {
        
        let upcomingEvents = events
        var genedArray = [eventRowInstance]()
        
            
            for event in self.currentEvents.dropFirst() {
                
                self.storedTableCurrentEvents = self.currentEvents
                
                
                let rowInstance = eventRowInstance(event: event)
                rowInstance.isCurrent = true
                
                if let CGcolor = event.calendar?.cgColor {
                    
                    let CalUIcolor = UIColor(cgColor: CGcolor)
                    rowInstance.eventTitleColour = (CalUIcolor)
                    
                }
                
                genedArray.append(rowInstance)
                
            }
                
            
            
            
            if upcomingEvents.isEmpty == false {
            
               // self.upcomingSection.setHidden(true)
            
            //  currentTableIdentifiers = IDS
            
                self.storedTableEvents = upcomingEvents
               
            
            for event in upcomingEvents {
                
                let cal: Calendar = Calendar(identifier: .gregorian)
                let midnightToday: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                let nextOccurDay: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: event.startDate)!
                let NXOsec = nextOccurDay.timeIntervalSince(midnightToday)
                let NXOdays = NXOsec/60/60/24
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let formattedEnd = dateFormatter.string(from: event.startDate)
                
                var dayText: String?
                
                switch NXOdays {
                case 0:
                    dayText = nil
                case 1:
                    dayText = "Tomorrow"
                default:
                    dayText = formattedEnd
                }
                
                let row = eventRowInstance(event: event)
                
                
                
              /*  let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let formattedEnd = dateFormatter.string(from: event.startDate)
                
                var dayText: String?
                
                switch NXOdays {
                case 0:
                    dayText = nil
                case 1:
                    dayText = "Tomorrow"
                default:
                    dayText = formattedEnd
                } */
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "h:mma"
                var startString = ""
                if let period = event.magdalenePeriod {
                    startString = "Period \(period)"
                } else {
                    startString = "\(dateFormatter2.string(from: event.startDate))"

                
                }
                
                if let safeDT = dayText {
                    
                    startString = "\(safeDT): \(startString)"
                    
                    
                } else {
                    
                    if event.magdalenePeriod == nil {
                        
                        startString = "\(dateFormatter2.string(from: event.startDate)) - \(dateFormatter2.string(from: event.endDate))"
                        
                    }
                    
                }
                        
                row.eventTimeText = startString
                
                if let loc = event.location {
                    row.eventLocationText = loc
                }
                
                if let CGcolor = event.calendar?.cgColor {
                    
                    let CalUIcolor = UIColor(cgColor: CGcolor)
                    row.eventTitleColour = (CalUIcolor)
                    
                } else {
                    
                    row.eventTitleColour = UIColor.white
                    
                }
                row.eventTitleText = event.title
                
                
                
                genedArray.append(row)
                
            }
            
                self.generatedEventRows = genedArray
                
                
                
            
        }
        
            if self.generatedEventRows != self.populatedWith || events.first?.endDate.formattedDate() != Date().formattedDate() {
               
                self.populateUpcomingEventsTable()
                
            }
            
            self.generatedEventRows = genedArray
        
            if self.generatedEventRows.isEmpty == true {
                
                self.upcomingSection.setHidden(true)
                
            } else {
                
                self.upcomingSection.setHidden(false)
                
            }
            
    
            
            }
    
        
    }
        
        combinedCurrentAndUpcoming = combinedTemp
        
    }
    
    func populateUpcomingEventsTable() {
        
        
            
            var arrayOfRowTypes = [String]()
            
            for item in generatedEventRows {
                
                if item.isCurrent == true {
                    
                    arrayOfRowTypes.append("CurrentEventRow")
                    
                } else {
                    
                    arrayOfRowTypes.append("EventRowID")
                    
                }
                
                
            }
            
            upcomingEventsTable.setRowTypes(arrayOfRowTypes)
            
            upcomingSection.setHidden(false)
            
            for (index, rowContents) in generatedEventRows.enumerated() {
                
            if rowContents.isCurrent == true {
                    
               let row = self.upcomingEventsTable.rowController(at: index) as! currentEventRow
                row.infoLabel.setHidden(true)
                row.titleLabel.setText("\(rowContents.event.title) \(rowContents.event.endsInString) in")
                
                row.timerLabel.setDate(rowContents.event.endDate.addingTimeInterval(1))
                row.timerLabel.setTextColor(rowContents.eventTitleColour)
                
                
                row.timerLabel.start()
                    
                
                    
                    
            } else {
                    
                
                let row = self.upcomingEventsTable.rowController(at: index) as! EventRow
                row.eventTitleLabel.setText(rowContents.eventTitleText)
                row.eventTitleLabel.setTextColor(rowContents.eventTitleColour)
                row.eventTimeLabel.setText(rowContents.eventTimeText)
                
                if let locLabelText = rowContents.eventLocationText {
                    
                    row.eventLocationLabel.setText(locLabelText)
                    row.eventLocationLabel.setHidden(false)
                    
                } else {
                    
                    row.eventLocationLabel.setHidden(true)
                    
                    
                }
                
            }
                
            }
        
        populatedWith = generatedEventRows
    
        
    }
    
    
    var populatedWith = [eventRowInstance]()
    
    
    func eventHalfDone(event: HLLEvent) {
    }
    
    @IBAction func infoLabelTapped(_ sender: Any) {
        
        print("Tapped")
        
        
    }
    
    
    
    
    @IBAction func countdownViewTapped(_ sender: Any) {
        
        if let safeCurrent = currentEvents.first {
            
            pushController(withName: "eventView", context: (safeCurrent, nextOccurEvent))
            
        }
        
        
        
    }
    
        
    
}


class EventRow: NSObject {
    
    
    
    
    @IBOutlet weak var eventTitleLabel: WKInterfaceLabel!
    @IBOutlet var eventTimeLabel: WKInterfaceLabel!
    @IBOutlet var eventLocationLabel: WKInterfaceLabel!
    
    
    
}

class eventRowInstance: Equatable {
    static func == (lhs: eventRowInstance, rhs: eventRowInstance) -> Bool {
        return lhs.event == rhs.event && lhs.isCurrent == rhs.isCurrent
    }
    
 
    init(event inEvent: HLLEvent) {
        
        event = inEvent
        
        
        
        
    }
    
    var eventTitleText = ""
    var eventTitleColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var eventLocationText: String?
    var eventTimeText = ""
    
    var isCurrent = false
    
    var event: HLLEvent
    
}

class currentEventRow: NSObject {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var timerLabel: WKInterfaceTimer!
    @IBOutlet var infoLabel: WKInterfaceLabel!
    
}


class Prefs: WKInterfaceController {
    
    
    @IBOutlet var largeCountdownText: WKInterfaceSwitch!
    
    
    override func awake(withContext context: Any?) {
        
        
        
        print("large: \(HLLDefaults.complication.largeCountdown)")
    
        
            self.largeCountdownText.setOn(HLLDefaults.complication.largeCountdown)
            
        
    }
    
    override func willActivate() {
        
            
            self.largeCountdownText.setOn(HLLDefaults.complication.largeCountdown)

    }
    
    @IBAction func largeCountdownTextSwitched(_ value: Bool) {
        
        HLLDefaults.complication.largeCountdown = value
        
        updateComplication()
        
        
    }
    
    func updateComplication() {
        
        DispatchQueue.main.async {
        
        
        if let entries = CLKComplicationServer.sharedInstance().activeComplications {
            
            
            
                for complicationItem in entries  {
                    
                    print("Reload3")
                    
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: complicationItem)
                    
                }
                
            
        }
        
    }
    }
    
    
}
